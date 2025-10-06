#!/usr/bin/env bash
set -euo pipefail

# One-click first-time server setup for n8n using templates in ./server
# - Copies docker-compose.yml and .env template to server
# - Starts n8n via docker compose
# - Does NOT set credentials; you will fill .env on server after copy

ROOT_DIR=$(cd "$(dirname "$0")"/.. && pwd)
cd "$ROOT_DIR"

ENV_FILE="$ROOT_DIR/.env.deploy"
if [ ! -f "$ENV_FILE" ]; then
  echo "Missing $ENV_FILE. Create it with DEPLOY_HOST, DEPLOY_USER, REMOTE_N8N_DIR, REMOTE_PROJECT_DIR (see README)." >&2
  exit 1
fi

# shellcheck disable=SC1090
set -a; source "$ENV_FILE"; set +a

required=(DEPLOY_HOST DEPLOY_USER REMOTE_N8N_DIR)
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

echo "Creating n8n directory on server: $REMOTE_N8N_DIR"
ssh "${SSH_OPTS[@]}" "${DEPLOY_USER}@${DEPLOY_HOST}" "mkdir -p '$REMOTE_N8N_DIR'"

echo "Copying docker-compose.yml and .env.example to server..."
scp "${SSH_OPTS[@]}" "$ROOT_DIR/server/docker-compose.yml" "${DEPLOY_USER}@${DEPLOY_HOST}":"$REMOTE_N8N_DIR/"
scp "${SSH_OPTS[@]}" "$ROOT_DIR/server/.env.example" "${DEPLOY_USER}@${DEPLOY_HOST}":"$REMOTE_N8N_DIR/.env"

echo "Starting n8n on server (first run). You can edit $REMOTE_N8N_DIR/.env afterwards and restart."
ssh "${SSH_OPTS[@]}" "${DEPLOY_USER}@${DEPLOY_HOST}" bash -s <<'REMOTE_CMDS'
set -euo pipefail
cd "$REMOTE_N8N_DIR"
docker compose pull
docker compose up -d
docker compose ps
echo "n8n started. Edit .env to set credentials and restart with: docker compose up -d"
REMOTE_CMDS

echo "First-time setup completed."


