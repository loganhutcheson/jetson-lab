#!/usr/bin/python3
"""Panini SSD1306 128x64 OLED clock on I2C bus 7, address 0x3c."""
import datetime
import fcntl
import os
import signal
import subprocess
import threading


def clock_labels(now):
    """Keep the large clock within 128 pixels; AM/PM belongs in the footer."""
    return (now.strftime('%a %b %d'), now.strftime('%I:%M').lstrip('0'),
            now.strftime('%p %Z') + ' JETSON')


def time_is_synced():
    """Read the existing NTP provider's synchronization state without changing it."""
    try:
        result = subprocess.run(
            ['/usr/bin/timedatectl', 'show', '--property=NTPSynchronized', '--value'],
            capture_output=True, text=True, timeout=5, check=False)
        return result.returncode == 0 and result.stdout.strip() == 'yes'
    except (OSError, subprocess.TimeoutExpired):
        return False


def wait_for_time():
    # Type=simple keeps the rest of boot independent of this clock. If the
    # network is unavailable, leave the display off instead of showing 1969.
    pause = threading.Event()
    while not time_is_synced():
        pause.wait(1)


def main():
    from PIL import Image, ImageDraw, ImageFont

    wait_for_time()
    pause = threading.Event()
    fd = os.open('/dev/i2c-7', os.O_RDWR)
    fcntl.ioctl(fd, 0x0703, 0x3c)

    def command(*values):
        for value in values:
            os.write(fd, bytes((0, value)))

    def show(image):
        command(0x21, 0, 127, 0x22, 0, 7)
        pixels = image.load()
        data = bytes(sum(bool(pixels[x, page * 8 + bit]) << bit for bit in range(8))
                     for page in range(8) for x in range(128))
        for start in range(0, len(data), 16):
            os.write(fd, b'\x40' + data[start:start + 16])

    command(0xae, 0xd5, 0x80, 0xa8, 63, 0xd3, 0, 0x40, 0x8d, 0x14,
            0x20, 0, 0xa1, 0xc8, 0xda, 0x12, 0x81, 0x60, 0xd9, 0xf1,
            0xdb, 0x40, 0xa4, 0xa6, 0xaf)
    font_path = '/usr/share/fonts/truetype/dejavu/DejaVuSansMono.ttf'
    large = ImageFont.truetype(font_path, 32)
    small = ImageFont.truetype(font_path, 10)

    def centered(draw, y, text, font):
        box = draw.textbbox((0, 0), text, font=font)
        draw.text(((128 - (box[2] - box[0])) // 2, y - box[1]),
                  text, font=font, fill=1)

    def stop(*args):
        raise SystemExit

    signal.signal(signal.SIGTERM, stop)
    try:
        while True:
            now = datetime.datetime.now().astimezone()
            image = Image.new('1', (128, 64))
            draw = ImageDraw.Draw(image)
            offset = (now.second // 15) % 2
            date_label, time_label, footer = clock_labels(now)
            centered(draw, offset, date_label, small)
            centered(draw, 15 + offset, time_label, large)
            centered(draw, 52 + offset, footer, small)
            show(image)
            pause.wait(1)
    finally:
        command(0xae)
        os.close(fd)


if __name__ == '__main__':
    main()
