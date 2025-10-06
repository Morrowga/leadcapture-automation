#!/usr/bin/env bash
set -euo pipefail

# One-command deploy: from local project, SSH to server, ensure n8n is running,
# copy workflows, and import them into n8n. Reads settings from .env.deploy.

ROOT_DIR=$(cd "$(dirname "$0")"/.. && pwd)
cd "$ROOT_DIR"

ENV_FILE="$ROOT_DIR/.env.deploy"
if [ ! -f "$ENV_FILE" ]; then
  echo "Missing $ENV_FILE. Copy .env.deploy.example to .env.deploy and fill values." >&2
  exit 1
fi

# shellcheck disable=SC1090
set -a; source "$ENV_FILE"; set +a

required=(DEPLOY_HOST DEPLOY_USER REMOTE_N8N_DIR REMOTE_PROJECT_DIR)
for var in "${required[@]}"; do
  if [ -z "${!var:-}" ]; then
    echo "Missing required var in .env.deploy: $var" >&2
    exit 1
  fi
done

SSH_OPTS=("-o" "StrictHostKeyChecking=no")
if [ -n "${DEPLOY_SSH_KEY:-}" ]; then
  SSH_OPTS+=("-i" "$DEPLOY_SSH_KEY")
fi

echo "Ensuring workflows directory exists locally..."
mkdir -p "$ROOT_DIR/workflows"

echo "Copying workflows to server..."
rsync -avz -e "ssh ${SSH_OPTS[*]}" "$ROOT_DIR/workflows/" "${DEPLOY_USER}@${DEPLOY_HOST}:${REMOTE_PROJECT_DIR}/workflows/"

echo "Starting/ensuring n8n is running and importing workflows..."
ssh "${SSH_OPTS[@]}" "${DEPLOY_USER}@${DEPLOY_HOST}" bash -s <<'REMOTE_CMDS'
set -euo pipefail

N8N_DIR="$REMOTE_N8N_DIR"
PROJECT_DIR="$REMOTE_PROJECT_DIR"

cd "$N8N_DIR"
docker compose pull
docker compose up -d

CID=$(docker compose ps -q n8n)
if [ -z "$CID" ]; then
  echo "n8n container not running" >&2
  exit 1
fi

docker cp "$PROJECT_DIR/workflows/." "$CID":/home/node/.n8n/workflows
docker compose exec -T n8n n8n import:workflow --input=/home/node/.n8n/workflows --overwrite
echo "Import complete."
REMOTE_CMDS

echo "Done."


