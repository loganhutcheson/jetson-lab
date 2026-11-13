# panini clock

Clock for the Panini case's SSD1306 128×64 OLED on the NVIDIA Jetson Orin Nano.
Uses `/dev/i2c-7`, address `0x3c`, matching the existing working case display.

Shows the local date, a **12-hour clock**, and an AM/PM + timezone footer.
The image shifts one pixel every 15 seconds; brightness and one-second refresh
match the original installed clock. The system timezone and time synchronization
remain owned by the operating system.

## install

On the Jetson, from this directory:

```sh
./install.sh "$USER"
```

The installer installs Pillow/fonts, backs up existing clock files under
`/var/backups/panini-clock/`, installs to `/opt/panini/clock.py`, and enables and
restarts `panini-clock.service`. It grants the selected service user I2C group
membership. It does not configure pinmux, drivers, or camera hardware.
Only one process should drive the OLED at a time.

## check and recover

```sh
systemctl status panini-clock.service --no-pager
journalctl -u panini-clock.service -n 30 --no-pager
```

To remove autostart and blank the display:

```sh
sudo systemctl disable --now panini-clock.service
```

To restore, copy the desired backed-up clock and service files to their original
paths, run `sudo systemctl daemon-reload`, then restart the service.
The program needs hardware to run; `clock_labels()` can be checked on any host
without opening the I2C device.
