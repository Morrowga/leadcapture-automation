### Twilio SMS Setup for Lead Capture

- **Goal**: Send SMS notifications for high-priority leads via Twilio.

### 1) Create Twilio Account
- Sign up at `https://www.twilio.com/`
- Get your Account SID and Auth Token from the Console Dashboard
- Purchase a phone number for sending SMS

### 2) Configure in Google Sheets (`Config` tab)
Add or update these rows:

| Setting | Value | Enabled |
|---------|-------|---------|
| twilio_account_sid | YOUR_ACCOUNT_SID | TRUE |
| twilio_auth_token | YOUR_AUTH_TOKEN | TRUE |
| twilio_from_number | +1234567890 | TRUE |
| twilio_to_number | +19876543210 | TRUE |

- Set Enabled to TRUE for all Twilio settings to activate SMS alerts.

### 3) Configure Twilio Credentials in n8n
1. In n8n, go to **Credentials** → **Add Credential**
2. Select **Twilio**
3. Enter your Account SID and Auth Token
4. Test the connection

### 4) How the workflow uses it
- The workflow reads Twilio settings from the `Config` sheet
- SMS messages include: priority label, name, email, phone, lead score, source, lead ID, message, and timestamp
- SMS is sent via the "Send an SMS/MMS/WhatsApp message" node

### 5) Test
- Trigger a test lead (see `TESTING.md`)
- Verify SMS is received on the configured `twilio_to_number`

### 6) Troubleshooting
- If no SMS appears: verify all Twilio settings are correct and Enabled is TRUE
- Check n8n execution logs for errors around the Twilio SMS node
- Ensure your Twilio account has sufficient credits
- Verify the phone numbers are in E.164 format (+1234567890)
