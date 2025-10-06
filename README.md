# Enterprise Lead Capture System

A comprehensive, configurable lead capture workflow built on n8n that automatically scores, routes, and integrates leads with your sales stack.

## Features

✅ **Smart Lead Scoring** - Configurable scoring rules based on lead quality  
✅ **Priority Routing** - Automatic HIGH/MEDIUM/LOW prioritization  
✅ **Duplicate Prevention** - 5-minute window duplicate checking  
✅ **Multi-Channel Notifications** - Slack, Discord, Twilio SMS, AWS SNS  
✅ **CRM Integration** - HubSpot, Salesforce, Custom Webhooks  
✅ **Priority-Based Email Alerts** - Different routing for each priority level  
✅ **Error Handling** - Comprehensive error logging and admin alerts  
✅ **Google Sheets Database** - Automatic lead storage with priority separation  

## System Requirements

- n8n instance (self-hosted or cloud)
- Google Sheets API access
- Email service (SMTP or Gmail)
- Optional: Slack, Discord, Twilio, AWS SNS, HubSpot, Salesforce accounts

## Quick Start

1. Import the n8n workflow JSON (`Leads.json`)
2. Set up Google Sheets database and config
3. Configure your integrations
4. Test the webhook endpoint
5. Integrate with your forms/website

## Documentation

- [Setup Guide](SETUP.md) — Complete installation instructions
- [Google Sheets](GOOGLESHEET.md) — Database tabs, config, scoring, metadata
- [Slack](SLACK.md) — Incoming webhook setup
- [Discord](DISCORD.md) — Webhook setup
- [Twilio](TWILIO.md) — SMS notifications
- [HubSpot](HUBSPOT.md) — CRM integration
- [Testing](TESTING.md) — cURL examples and validation

## Files in this repo

- `Leads.json` — n8n workflow (import into n8n)
- `Lead Capture Database.xlsx` — example sheet structure
- `SETUP.md` — end-to-end setup
- `GOOGLESHEET.md` — Google Sheets mapping
- `SLACK.md` — Slack integration guide
- `DISCORD.md` — Discord integration guide
- `TWILIO.md` — Twilio SMS guide
- `HUBSPOT.md` — HubSpot CRM guide
- `TESTING.md` — testing playbook

## Support

For issues or questions, contact: [your-email@company.com]

## License

[Your License Type]