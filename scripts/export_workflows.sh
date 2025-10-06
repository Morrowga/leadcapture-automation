#!/usr/bin/env bash
set -euo pipefail

# Exports all n8n workflows from the running docker compose service to ./workflows

ROOT_DIR=$(cd "$(dirname "$0")"/.. && pwd)
cd "$ROOT_DIR"

if ! command -v docker &>/dev/null; then
  echo "docker not found" >&2
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

docker compose exec -T n8n n8n export:workflow --all --separate --output=/home/node/.n8n/exports
mkdir -p "$ROOT_DIR/workflows"
docker cp "$CID":/home/node/.n8n/exports/. "$ROOT_DIR/workflows"
echo "Exported workflows to $ROOT_DIR/workflows"


