#!/usr/bin/env bash
set -euo pipefail
clock_user="${1:-${SUDO_USER:-$USER}}"
id "$clock_user" >/dev/null
[[ "$clock_user" =~ ^[a-z_][a-z0-9_-]*[$]?$ ]] || { echo 'Invalid service user' >&2; exit 1; }
project_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
sudo apt-get install -y python3-pil fonts-dejavu-core
getent group i2c >/dev/null || sudo groupadd --system i2c
[[ -e /dev/i2c-7 ]] || { echo '/dev/i2c-7 missing; check board wiring/configuration' >&2; exit 1; }
sudo usermod -aG i2c "$clock_user"
backup_dir="/var/backups/panini-clock/$(date +%Y%m%d-%H%M%S)"
sudo mkdir -p "$backup_dir" /opt/panini
for clock_file in /opt/panini/clock.py /etc/systemd/system/panini-clock.service; do
  if [[ -f "$clock_file" ]]; then sudo cp -p "$clock_file" "$backup_dir/$(basename "$clock_file")"; fi
done
sudo install -m 644 "$project_dir/clock.py" /opt/panini/clock.py
sed "s/@USER@/$clock_user/" "$project_dir/panini-clock.service" | sudo tee /etc/systemd/system/panini-clock.service >/dev/null
sudo systemctl daemon-reload
sudo systemctl enable panini-clock.service
sudo systemctl restart panini-clock.service
sudo systemctl --no-pager --full status panini-clock.service
