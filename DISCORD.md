### Discord Setup for Lead Capture

- **Goal**: Receive priority-based lead alerts in a Discord channel via webhook.

### 1) Create a Discord Webhook
- In your Discord server, go to: Server Settings → Integrations → Webhooks
- Click “New Webhook” → choose the target channel → copy the Webhook URL

### 2) Configure in Google Sheets (`Config` tab)
Add or update these rows:

| Setting | Value | Enabled |
|---------|-------|---------|
| discord_webhook_url | https://discord.com/api/webhooks/… | TRUE |

- Set Enabled to TRUE to activate Discord alerts.

### 3) How the workflow uses it
- The workflow reads `discord_webhook_url` from the `Config` sheet.
- If present and enabled, notifications include an embed with: name, email, phone, company, lead score, priority label, source, response time, assigned_to, duplicate flag, lead id, and message.

### 4) Test
- Trigger a test lead (see `TESTING.md`).
- Verify a message appears in your Discord channel with the expected fields.

### 5) Troubleshooting
- If no message appears: ensure `discord_webhook_url` is valid and Enabled is TRUE.
- Check n8n execution logs for errors near `Discord` or `Slack/Discord Notification Routes`.
- Confirm your Discord role permissions allow webhook posting to the channel.
