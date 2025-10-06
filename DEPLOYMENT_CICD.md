# Deployment & CI/CD for n8n Workflows

This guide explains how to version workflows in Git, export/import JSON from an n8n server via commands, and automate deployments with CI/CD.

## 1) Repository structure

```
leadcapture/
  workflows/               # versioned n8n workflows (JSON)
  scripts/                 # helper scripts for import/export
  DEPLOYMENT_CICD.md
  N8N_SETUP.md
```

## 2) Export workflows from server -> repo

On the n8n server container:

```bash
# Export each workflow to its own JSON file
docker compose exec n8n n8n export:workflow \
  --all \
  --separate \
  --output=/home/node/.n8n/exports

# Copy exports from container to host
docker cp $(docker compose ps -q n8n):/home/node/.n8n/exports ./workflows
```

Commit `./workflows/*.json` to Git.

## 3) Import workflows from repo -> server

From your project folder (host machine), copy to the container and import:

```bash
# Copy repo workflows into the container
docker cp ./workflows $(docker compose ps -q n8n):/home/node/.n8n/workflows

# Import into n8n
docker compose exec n8n n8n import:workflow \
  --input=/home/node/.n8n/workflows
```

Flags you can add:
- `--overwrite` to replace existing workflows with same IDs.
- `--userId=<ownerId>` to assign ownership.

## 4) Helper scripts (optional)

Create simple scripts in `scripts/` for repeatable operations.

```bash
# scripts/export_workflows.sh
set -euo pipefail
docker compose exec n8n n8n export:workflow --all --separate --output=/home/node/.n8n/exports
docker cp $(docker compose ps -q n8n):/home/node/.n8n/exports ./workflows
```

```bash
# scripts/import_workflows.sh
set -euo pipefail
docker cp ./workflows $(docker compose ps -q n8n):/home/node/.n8n/workflows
docker compose exec n8n n8n import:workflow --input=/home/node/.n8n/workflows --overwrite
```

Make executable:

```bash
chmod +x scripts/*.sh
```

## 5) GitHub Actions CI/CD example

Requires:
- Self-hosted runner with Docker access (recommended) or remote SSH step
- Secrets set in repository: `SSH_HOST`, `SSH_USER`, `SSH_KEY`

```yaml
name: Deploy n8n Workflows

on:
  push:
    branches: [ main ]
    paths:
      - 'workflows/**.json'
      - '.github/workflows/deploy-n8n.yml'

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Copy workflows to server
        uses: appleboy/scp-action@v0.1.7
        with:
          host: ${{ secrets.SSH_HOST }}
          username: ${{ secrets.SSH_USER }}
          key: ${{ secrets.SSH_KEY }}
          source: 'workflows/*'
          target: '~/leadcapture/workflows'

      - name: Import on server
        uses: appleboy/ssh-action@v1.0.3
        with:
          host: ${{ secrets.SSH_HOST }}
          username: ${{ secrets.SSH_USER }}
          key: ${{ secrets.SSH_KEY }}
          script: |
            cd ~/n8n
            docker compose ps -q n8n
            docker cp ~/leadcapture/workflows $(docker compose ps -q n8n):/home/node/.n8n/workflows
            docker compose exec -T n8n n8n import:workflow --input=/home/node/.n8n/workflows --overwrite
```

Notes:
- The workflow copies JSONs to the server and runs the import command inside the n8n container.
- Adjust paths to match your server layout.

## 6) Promotion between environments

- Keep separate n8n instances for dev/staging/prod.
- Export from lower env, review in Git, then import into higher env via CI/CD.
- Keep credentials per environment on their respective servers.

## 7) Rollbacks

- Revert the Git commit with the prior JSONs.
- Re-run the CI/CD job to re-import previous versions (with `--overwrite`).


