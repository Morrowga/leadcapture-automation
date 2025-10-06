### Slack Setup for Lead Capture

- **Goal**: Send priority-based lead alerts to a Slack channel using Incoming Webhooks.

### 1) Create a Slack Incoming Webhook
- Go to `https://api.slack.com/messaging/webhooks`
- Create a new app (if needed) → Add Incoming Webhooks → Install to workspace
- Choose your target channel → copy the Webhook URL

### 2) Configure in Google Sheets (`Config` tab)
Add or update these rows:

| Setting | Value | Enabled |
|---------|-------|---------|
| slack_webhook_url | YOUR_WEBHOOK_URL | TRUE |
| slack_channel | #leads | TRUE |

- Set both rows’ Enabled to TRUE to activate Slack alerts.

### 3) How the workflow uses it
- The workflow reads `slack_webhook_url` and `slack_channel` from the `Config` sheet.
- Slack messages include: name, email, phone, company, lead score, priority label, source, duplicate flag, assigned_to, response_time, message, and timestamp.

### 4) Test
- Trigger a test lead (see `TESTING.md`).
- Check your Slack channel for the formatted lead alert.

### 5) Troubleshooting
- If no message appears: verify webhook URL and channel name; ensure Enabled is TRUE in both rows.
- Check n8n execution logs for errors around `Slack Webhook` or `Notification Routes`.
- Ensure the Slack app has permission to post to the target channel.
