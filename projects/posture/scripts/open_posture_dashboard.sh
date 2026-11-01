#!/usr/bin/env bash
set -euo pipefail

host="${1:-jetson.local}"
remote_port="${POSTURE_DASHBOARD_PORT:-8787}"
local_port="${POSTURE_DASHBOARD_LOCAL_PORT:-8787}"
user="${POSTURE_DASHBOARD_SSH_USER:-logan}"

direct_url="http://${host}:${remote_port}/"
local_url="http://127.0.0.1:${local_port}/"

echo "[dashboard] checking ${direct_url}"
if curl -fsS --max-time 3 "${direct_url}" >/dev/null; then
  echo "[dashboard] direct dashboard reachable"
  open "${direct_url}"
  exit 0
fi

echo "[dashboard] direct dashboard unavailable, creating SSH tunnel on localhost:${local_port}"
ssh -f -N \
  -L "${local_port}:127.0.0.1:${remote_port}" \
  "${user}@${host}"

echo "[dashboard] opening ${local_url}"
open "${local_url}"
