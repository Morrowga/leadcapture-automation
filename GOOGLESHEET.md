### Google Sheets Setup

- **Goal**: Store leads by priority and centralize configuration for notifications, email, and CRM.

### 1) Create Spreadsheet: `Lead Capture Database`
Create these tabs:
- `High` — High-priority leads
- `Medium` — Medium-priority leads
- `Low` — Low-priority leads
- `Errors` — Error logs for email/notifications/CRM
- `Config` — Integration and global settings
- `Scoring_Rules` — Points for scoring logic
- `Metadata` — Priority response policies

### 2) Columns for Lead Tabs
Recommended columns for `High`, `Medium`, `Low`:
- Name, Email, Phone, Company, Message, Source, Score, Priority, Created, Lead ID

Note: The workflow uses “Lead ID” as the matching key for updates.

### 3) Config Tab
Add rows like:

| Setting | Value | Enabled |
|---------|-------|---------|
| slack_webhook_url | YOUR_WEBHOOK_URL | TRUE |
| slack_channel | #leads | TRUE |
| discord_webhook_url | YOUR_WEBHOOK_URL | TRUE |
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
| twilio_account_sid | (optional) | TRUE |
| twilio_auth_token | (optional) | TRUE |
| twilio_from_number | (optional) | TRUE |
| twilio_to_number | (optional) | TRUE |
| sns_region | (optional) | TRUE |
| sns_topic_arn | (optional) | TRUE |
| sns_phone_number | (optional) | TRUE |

Only set Enabled to TRUE where you want the integration active.

### 4) Scoring_Rules Tab
Example rules:

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

### 5) Metadata Tab

| Priority | response_time | urgency | assigned_to |
|----------|---------------|---------|-------------|
| HIGH | immediate | critical | sales-team-lead |
| MEDIUM | 4_hours | moderate | sales-team |
| LOW | 24_hours | low | nurture-team |

### 6) Connect in n8n
- Add Google Sheets OAuth2 credential.
- Point nodes to `Lead Capture Database` and the appropriate tabs (`High`, `Medium`, `Low`, `Errors`, `Config`, `Scoring_Rules`, `Metadata`).

### 7) Verify
- Trigger a test lead (see `TESTING.md`).
- Confirm rows are appended/updated in the correct priority tab and that errors (if any) log to `Errors`.
