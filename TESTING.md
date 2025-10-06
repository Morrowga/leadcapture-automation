# Testing Guide

Complete guide for testing the lead capture workflow with various scenarios and payloads.

---

## Setup

Replace `YOUR_WEBHOOK_URL` with your actual n8n webhook URL (test path is `/webhook-test/leads`):
```bash
export WEBHOOK_URL="http://localhost:5678/webhook-test/leads"
```

--- 

## Minimum Payload

```bash
curl -X POST "$WEBHOOK_URL" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Quick Test",
    "email": "test@example.com"
  }'
```

Expected: 200 OK with success message.

--- 

## LOW Priority

```bash
curl -X POST "$WEBHOOK_URL" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "John Doe",
    "email": "john@gmail.com",
    "message": "Hi, I\'m interested",
    "source": "website"
  }'
```

--- 

## Medium Priority

```bash
curl -X POST "$WEBHOOK_URL" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Sarah Johnson",
    "email": "sarah@techstartup.com",
    "phone": "+1234567890",
    "message": "We\'re looking for a solution to manage our growing sales team. Currently using spreadsheets.",
    "source": "website"
  }'
```

--- 

## High Priority

```bash
curl -X POST "$WEBHOOK_URL" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Michael Chen",
    "email": "michael.chen@enterprise.com",
    "phone": "+19876543210",
    "company": "Enterprise Solutions Corp",
    "website": "https://enterprisesolutions.com",
    "message": "We\'re ready to migrate from our current system. We have a team of 200 sales reps and need implementation within 60 days. Budget approved for 100 usd annually. Can we schedule a demo this week?",
    "budget": "100000",
    "source": "google-ads",
    "industry": "Technology",
    "job_title": "VP of Sales"
  }'
```

--- 

## B2B Custom Fields

These fields are scored via `Scoring_Rules` when prefixed (e.g., `custom_industry`). The workflow is field-agnostic and will include non-internal fields in notifications.

```bash
curl -X POST "$WEBHOOK_URL" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Lisa Martinez",
    "email": "lisa@saascompany.io",
    "phone": "+15551234567",
    "company": "SaaS Company",
    "website": "https://saascompany.io",
    "message": "Looking for enterprise plan for our 50-person sales team",
    "budget": "$50,000",
    "source": "linkedin",
    "industry": "Software",
    "job_title": "Director of Sales",
    "employees": "150",
    "revenue": "$10M",
    "current_tool": "Salesforce",
    "pain_point": "Too expensive"
  }'
```

---

## What affects scoring and routing
- **Contact completeness**: phone, company, website, budget
- **Email domain**: business vs free email provider
- **Message length**: short/medium/long thresholds
- **Source**: paid vs organic
- **Custom fields**: any present `custom_*` rule in `Scoring_Rules`

## Notifications and CRM
- Slack/Discord send only if enabled in `Config`
- SMS (Twilio) sends only if `twilio_*` settings are enabled
- Emails send based on priority and `email_*_enabled`
- CRM routes only if `crm_enabled` and specific CRM flags are enabled
- HubSpot creates contacts and deals if `hubspot_api_key` is enabled

## Duplicates
- A 5-minute window duplicate check runs across High/Medium/Low by Email

---

## Testing SMS Notifications

To test Twilio SMS integration:

1. Ensure `twilio_account_sid`, `twilio_auth_token`, `twilio_from_number`, and `twilio_to_number` are configured in `Config` tab
2. Set all Twilio settings' Enabled to TRUE
3. Send a test lead (any priority)
4. Check your phone for SMS notification

---

## Testing CRM Integration

To test HubSpot integration:

1. Ensure `crm_enabled` and `hubspot_api_key` are configured in `Config` tab
2. Set both settings' Enabled to TRUE
3. Send a test lead with company and phone information
4. Check your HubSpot account for new contact and deal

---

## Troubleshooting
- Check n8n execution logs for failed nodes
- Verify Google credentials and sheet/tab names
- Ensure webhook URLs and Enabled flags are correct in `Config`


