#!/usr/bin/env bash
set -euo pipefail

# Imports all workflows from ./workflows into the running n8n docker compose service

ROOT_DIR=$(cd "$(dirname "$0")"/.. && pwd)
cd "$ROOT_DIR"

if ! command -v docker &>/dev/null; then
  echo "docker not found" >&2
  exit 1
fi

if [ ! -d "$ROOT_DIR/workflows" ]; then
  echo "No workflows directory found at $ROOT_DIR/workflows" >&2
  exit 1
fi

cd ~/n8n || {
  echo "Expected n8n docker-compose project at ~/n8n" >&2
  exit 1
}

CID=$(docker compose ps -q n8n)
if [ -z "$CID" ]; then
  echo "n8n container not running" >&2
  exit 1
fi

docker cp "$ROOT_DIR/workflows/." "$CID":/home/node/.n8n/workflows
docker compose exec -T n8n n8n import:workflow --input=/home/node/.n8n/workflows --overwrite
echo "Imported workflows from $ROOT_DIR/workflows"


