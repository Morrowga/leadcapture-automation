# n8n Deployment Setup - Complete Guide

Deploy n8n to your server with one-click scripts for initial setup and ongoing workflow deployments.

## Prerequisites

### On Your Server
- Docker and docker compose installed
- SSH access (with user and optional SSH key)
- Ports open: 5678 (n8n UI) or 80/443 if using a domain

### In This Repo
Before starting, ensure you have:
- `server/docker-compose.yml` - Docker compose configuration for n8n
- `server/.env.example` - Template environment file with variables like:
  - `N8N_HOST` (your domain or IP)
  - `N8N_PORT` (default: 5678)
  - `N8N_BASIC_AUTH_USER` and `N8N_BASIC_AUTH_PASSWORD`
  - Other n8n configuration

---

## One-Time Setup (From Your Laptop)

### Step 1: Create `.env.deploy`

Create `.env.deploy` in the project root with your server details:
```bash
# Server connection
DEPLOY_HOST=your.server.com          # Your server IP or domain
DEPLOY_USER=ubuntu                   # SSH user
DEPLOY_SSH_KEY=                      # Optional: path to SSH key (leave empty for default)

# Server paths
REMOTE_N8N_DIR=/home/ubuntu/n8n              # Where n8n docker-compose will run
REMOTE_PROJECT_DIR=/home/ubuntu/leadcapture  # Where this repo will live on server
```

**Important**: Both directories should be under your user's home to avoid permission issues.

### Step 2: Run First-Time Setup

This copies the docker-compose setup to your server and starts n8n:
```bash
chmod +x scripts/*.sh
./scripts/first_setup.sh
```

**What this does:**
- Creates `REMOTE_N8N_DIR` on the server
- Copies `server/docker-compose.yml` and `server/.env.example` to the server
- Starts n8n container (accessible but not fully configured)

### Step 3: Configure n8n on Server

SSH to your server and edit the environment file:
```bash
ssh your.server.com
cd /home/ubuntu/n8n  # Or your REMOTE_N8N_DIR
nano .env
```

Fill in required values:
- `N8N_HOST` - Your domain or server IP
- `N8N_BASIC_AUTH_USER` and `N8N_BASIC_AUTH_PASSWORD`
- Any other n8n settings you need

Then restart n8n:
```bash
docker compose up -d
```

### Step 4: Copy Project to Server (for export/import scripts)

If you want to run export/import scripts directly on the server:
```bash
# From your laptop
rsync -avz -e "ssh -i ~/.ssh/your-key" \
  --exclude='.git' \
  --exclude='node_modules' \
  ./ your.server.com:/home/ubuntu/leadcapture/
```

Or use git:
```bash
ssh your.server.com
cd /home/ubuntu  # Or parent of REMOTE_PROJECT_DIR
git clone https://github.com/yourusername/yourrepo.git leadcapture
```

---

## Working with Workflows

### Deploy Workflows (From Your Laptop → Server)

To push your local workflows to the server:
```bash
./scripts/deploy.sh
```

**What this does:**
1. Copies `workflows/` directory from your laptop to server
2. Imports workflows into running n8n container (with --overwrite flag)

### Export Workflows (From Server → Repo)

To save current n8n workflows back to the repo (run **on the server**):
```bash
cd /home/ubuntu/leadcapture  # Your REMOTE_PROJECT_DIR
./scripts/export_workflows.sh
```

**What this does:**
1. Exports all workflows from n8n to `workflows/` directory
2. Then commit and push:
```bash
   git add workflows/
   git commit -m "Export workflows from server"
   git push
```

### Import Workflows (Manually on Server)

To import workflows that are already on the server (run **on the server**):
```bash
cd /home/ubuntu/leadcapture  # Your REMOTE_PROJECT_DIR
./scripts/import_workflows.sh
```

---

## n8n Configuration (In the UI)

After n8n is running, access it at `http://your.server.com:5678` and configure:

### 1. Credentials
- **Google Sheets** - OAuth2 credential for accessing your spreadsheet
- **SMTP/Gmail** - For sending notification emails

### 2. Workflow Configuration
Point workflow nodes to your Google Sheet tabs:
- `High` - High-priority leads
- `Medium` - Medium-priority leads  
- `Low` - Low-priority leads
- `Errors` - Error logging
- `Config` - Settings (webhook URLs, email config, etc.)
- `Scoring_Rules` - Lead scoring configuration
- `Metadata` - System metadata

### 3. Google Sheet Setup (Config Tab)
Fill in these values in your Config sheet:
- `slack_webhook_url` - For Slack notifications (optional)
- `discord_webhook_url` - For Discord notifications (optional)
- Email settings if not using credentials
- Any other workflow-specific configuration

---

## Common Commands

### On Your Laptop
```bash
# Deploy workflows to server
./scripts/deploy.sh
```

### On the Server
```bash
# Restart n8n
cd /home/ubuntu/n8n && docker compose restart

# View n8n logs
cd /home/ubuntu/n8n && docker compose logs -f n8n

# Export workflows
cd /home/ubuntu/leadcapture && ./scripts/export_workflows.sh

# Import workflows
cd /home/ubuntu/leadcapture && ./scripts/import_workflows.sh
```

---

## Troubleshooting

### "n8n container not running"
```bash
cd /home/ubuntu/n8n
docker compose ps
docker compose up -d
```

### "Missing $ENV_FILE"
Create `.env.deploy` in your project root with the values from Step 1.

### Scripts have hardcoded paths
`export_workflows.sh` and `import_workflows.sh` expect n8n at `~/n8n`. If your `REMOTE_N8N_DIR` is different, you'll need to edit these scripts or create a symlink:
```bash
ln -s /your/actual/n8n/path ~/n8n
```

### Permission denied
Make sure your user owns both directories:
```bash
sudo chown -R $USER:$USER /home/ubuntu/n8n /home/ubuntu/leadcapture
```

---

## Quick Reference

| Action | Command | Where |
|--------|---------|-------|
| Initial setup | `./scripts/first_setup.sh` | Laptop |
| Deploy workflows | `./scripts/deploy.sh` | Laptop |
| Export workflows | `./scripts/export_workflows.sh` | Server |
| Import workflows | `./scripts/import_workflows.sh` | Server |
| Restart n8n | `cd ~/n8n && docker compose restart` | Server |
| View logs | `cd ~/n8n && docker compose logs -f` | Server |