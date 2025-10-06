# Setup Guide

## Prerequisites

- Active n8n instance
- Google account with Sheets access
- Email service credentials (SMTP or Gmail)
- Optional: Slack, Discord, HubSpot, Salesforce, Twilio, AWS SNS accounts

## Step 1: Import Workflow

1. Open n8n → Workflows → Import from File
2. Select `Leads.json` from this repo
3. Click **Import**

## Step 2: Create Google Sheets

### 2.1 Create Main Spreadsheet

1. Create a new Google Sheet named `Lead Capture Database`
2. Create tabs:
   - `High`
   - `Medium`
   - `Low`
   - `Errors`
   - `Config`
   - `Scoring_Rules`
   - `Metadata`

Tip: `Lead Capture Database.xlsx` in this repo can serve as a reference for tab structure.

### 2.2 Set Up Tab Structures

#### Config Tab (examples)

| Setting | Value | Enabled |
|---------|-------|---------|
| slack_webhook_url | YOUR_WEBHOOK_URL | TRUE |
| slack_channel | #leads | TRUE |
| discord_webhook_url | YOUR_WEBHOOK_URL | FALSE |
| email_high_enabled | - | TRUE |
| email_high_from | sales@yourcompany.com | TRUE |
| email_high_to | sales-lead@yourcompany.com | TRUE |
| email_medium_enabled | - | TRUE |
| email_medium_from | sales@yourcompany.com | TRUE |
| email_medium_to | sales-team@yourcompany.com | TRUE |
| email_error_enabled | - | TRUE |
| email_error_from | alerts@yourcompany.com | TRUE |
| email_error_to | admin@yourcompany.com | TRUE |
| crm_enabled | - | FALSE |
| hubspot_api_key | (optional) | TRUE |
| salesforce_instance_url | (optional) | TRUE |
| salesforce_access_token | (optional) | TRUE |
| crm_webhook_url | (optional) | TRUE |

#### Scoring_Rules Tab

| Rule | Points |
|------|--------|
| has_phone | 15 |
| has_company | 20 |
| has_website | 10 |
| has_budget | 25 |
| email_business | 20 |
| email_free | 5 |
| message_long | 15 |
| message_medium | 10 |
| message_short | 5 |
| priority_high_threshold | 70 |
| priority_medium_threshold | 40 |

#### Metadata Tab

| Priority | response_time | urgency | assigned_to |
|----------|---------------|---------|-------------|
| HIGH | immediate | critical | sales-team-lead |
| MEDIUM | 4_hours | moderate | sales-team |
| LOW | 24_hours | low | nurture-team |

## Step 3: Connect Google Sheets to n8n

1. In n8n, go to **Credentials** → **Add Credential**
2. Select **Google Sheets OAuth2 API**
3. Complete OAuth and test the connection

## Step 4: Update Workflow Nodes

- Point all Google Sheets nodes to your `Lead Capture Database` spreadsheet
- Set sheet names exactly as: `High`, `Medium`, `Low`, `Errors`, `Config`, `Scoring_Rules`, `Metadata`

## Step 5: Configure Email

1. Go to **Credentials** → **Add Credential**
2. Choose **SMTP** (or Gmail)
3. Enter your credentials and test

## Step 6: Configure Integrations (Optional)

See:
- `SLACK.md` for Slack Incoming Webhooks
- `DISCORD.md` for Discord webhooks
- `TWILIO.md` for SMS notifications
- `HUBSPOT.md` for CRM integration
- `GOOGLESHEET.md` for database/config mapping

## Step 7: Activate and Test

1. Click the workflow **Active** toggle
2. Copy the webhook URL for the `Webhook` node (path: `leads`)
3. Use examples in `TESTING.md` to send test requests
4. Verify data in the corresponding priority tabs and that notifications/emails are delivered
