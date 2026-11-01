#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
SERVICE_SRC="${SCRIPT_DIR}/posture-dashboard.service"
SERVICE_DST="/etc/systemd/system/posture-dashboard.service"
ENV_DST="/etc/default/posture-dashboard"
ENV_EXAMPLE="${SCRIPT_DIR}/posture-dashboard.env.example"

service_user="${SUDO_USER:-${USER:-$(id -un)}}"
unit_tmp="$(mktemp)"
trap 'rm -f "$unit_tmp"' EXIT
python3 - "$SERVICE_SRC" "$unit_tmp" "$REPO_ROOT" "$service_user" <<'PYUNIT'
from pathlib import Path
import sys
source, target, root, user = sys.argv[1:]
# Escape systemd specifiers and quote paths (including checkout names with spaces).
root = root.replace('%', '%%').replace('\\', '\\\\').replace('"', '\\"')
text = Path(source).read_text().replace('@SERVICE_USER@', user)
text = text.replace('WorkingDirectory=@PROJECT_ROOT@', f'WorkingDirectory="{root}"')
text = text.replace('ExecStart=@PROJECT_ROOT@/jetson/services/', f'ExecStart="{root}/jetson/services/')
text = '\n'.join(line + '"' if line.startswith('ExecStart=') else line for line in text.splitlines()) + '\n'
Path(target).write_text(text)
PYUNIT
sudo install -m 0644 "${unit_tmp}" "${SERVICE_DST}"
if [[ ! -f "${ENV_DST}" ]]; then
  sudo install -m 0644 "${ENV_EXAMPLE}" "${ENV_DST}"
fi
sudo chmod +x "${SCRIPT_DIR}/run_posture_dashboard.sh"
sudo systemctl daemon-reload
echo "installed ${SERVICE_DST}"
echo "env file: ${ENV_DST}"
echo "next steps:"
echo "  sudo systemctl enable --now posture-dashboard.service"
