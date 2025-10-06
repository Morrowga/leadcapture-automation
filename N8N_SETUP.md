# n8n Server Setup Guide

This guide helps you deploy a secure, production-ready n8n instance and prepare it for workflow imports from this project.

## 1) Choose a deployment method

- Docker (recommended)
- n8n Cloud (skip infra steps; only configure environment)

## 2) Docker deployment (recommended)

Create a `docker-compose.yml` on your server:

```yaml
version: '3.8'
services:
  n8n:
    image: n8nio/n8n:latest
    restart: unless-stopped
    ports:
      - '5678:5678'
    environment:
      - N8N_HOST=${N8N_HOST}
      - N8N_PORT=5678
      - N8N_PROTOCOL=https
      - WEBHOOK_URL=https://${N8N_HOST}/
      - GENERIC_TIMEZONE=${GENERIC_TIMEZONE:-UTC}
      - N8N_ENCRYPTION_KEY=${N8N_ENCRYPTION_KEY}
      - N8N_BASIC_AUTH_ACTIVE=true
      - N8N_BASIC_AUTH_USER=${N8N_BASIC_AUTH_USER}
      - N8N_BASIC_AUTH_PASSWORD=${N8N_BASIC_AUTH_PASSWORD}
      - NODE_FUNCTION_ALLOW_EXTERNAL=axios,lodash,dayjs
      - NODE_OPTIONS=--max-old-space-size=2048
    volumes:
      - n8n_data:/home/node/.n8n
volumes:
  n8n_data:
```

Create a `.env` file alongside `docker-compose.yml` with secure values:

```bash
N8N_HOST=your.domain.com
GENERIC_TIMEZONE=UTC
N8N_ENCRYPTION_KEY=replace-with-32+char-random-string
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=replace-with-strong-password
```

Start n8n:

```bash
docker compose pull && docker compose up -d
```

## 3) TLS and reverse proxy

Put n8n behind a reverse proxy (Nginx/Traefik/Caddy) with a valid TLS certificate. Example (Caddy):

```caddyfile
your.domain.com {
  reverse_proxy localhost:5678
}
```

Ensure `N8N_PROTOCOL=https` and `WEBHOOK_URL` match the public URL.

## 4) Create the owner user

Visit `https://your.domain.com` to create the first (owner) account. Keep these credentials safe.

## 5) Hardening checklist

- Enable basic auth (already set above) or SSO in front of n8n.
- Keep `N8N_ENCRYPTION_KEY` secret and backed up; it encrypts credentials at rest.
- Restrict server SSH access, enable automatic security updates.
- Backup volume `n8n_data` regularly.

## 6) Environment variables for workflows

Set any runtime variables your workflows need via Docker env or `.env` (e.g., Slack/Twilio/HubSpot tokens). Prefer secret managers or Docker secrets for sensitive values.

## 7) Using the n8n CLI on the server

The container includes a CLI you can run with `docker compose exec`:

```bash
# Export all workflows to a folder
docker compose exec n8n n8n export:workflow --all --separate --output=/home/node/.n8n/exports

# Import workflows from a folder
docker compose exec n8n n8n import:workflow --input=/home/node/.n8n/exports
```

Notes:
- `--separate` writes one file per workflow, easier for Git.
- Credentials are not exported by default in plaintext. Re-create credentials on the server or use secure export/import (see deployment guide).

## 8) Webhook URLs

Your workflows that start with Webhook triggers will be reachable at:

```
https://your.domain.com/webhook/<path>
```

Use the test URL variant during development if needed:

```
https://your.domain.com/webhook-test/<path>
```

## 9) Health and maintenance

- Check container logs: `docker compose logs -f n8n`
- Update n8n: `docker compose pull && docker compose up -d`
- Backup: snapshot `n8n_data` volume (files under `/home/node/.n8n`).


