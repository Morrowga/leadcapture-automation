### HubSpot CRM Integration Setup

- **Goal**: Automatically create contacts and deals in HubSpot for captured leads.

### 1) Get HubSpot API Access
- Go to `https://app.hubspot.com/settings/api/key`
- Generate a new Private App token
- Grant permissions for: Contacts (write), Deals (write)

### 2) Configure in Google Sheets (`Config` tab)
Add or update these rows:

| Setting | Value | Enabled |
|---------|-------|---------|
| crm_enabled | - | TRUE |
| hubspot_api_key | YOUR_PRIVATE_APP_TOKEN | TRUE |

- Set `crm_enabled` to TRUE to activate CRM routing
- Set `hubspot_api_key` Enabled to TRUE to enable HubSpot specifically

### 3) Configure HubSpot Credentials in n8n
1. In n8n, go to **Credentials** → **Add Credential**
2. Select **HubSpot**
3. Enter your Private App token
4. Test the connection

### 4) How the workflow uses it

#### Contact Creation ("Create or update a contact" node)
The workflow creates HubSpot contacts with these fields:
- **Email**: `{{ $json.email }}`
- **First Name**: `{{ $json.name.split(' ')[0] }}`
- **Last Name**: `{{ $json.name.split(' ').slice(1).join(' ') || '-' }}`
- **Phone**: `{{ $json.phone }}`
- **Company**: `{{ $json.company || 'Unknown Company' }}`

#### Custom Properties
- **lead_id**: `{{ $json.id }}`
- **lead_priority**: `high_priority`/`medium_priority`/`low_priority` (based on `$json.priority`)
- **lead_score**: `{{ $json.lead_score }}`
- **lead_source**: `{{ $json.source }}`

#### Deal Creation ("Create a deal" node)
After contact creation, the workflow creates a deal:
- **Deal Name**: `{{ $json.name }} - {{ $json.company || 'Lead' }}`
- **Stage**: 
  - HIGH priority → `appointmentscheduled`
  - MEDIUM priority → `qualifiedtobuy`
  - LOW priority → `appointmentscheduled`

#### Workflow Flow
1. Lead data flows to "CRM Routes" switch
2. If HubSpot enabled → "Create or update a contact"
3. Contact response → "Merge Response" (captures contact ID)
4. Merged data → "Create a deal"
5. Deal response → "Merge CRM Integrations"

### 5) Test
- Trigger a test lead (see `TESTING.md`)
- Check your HubSpot contacts and deals to verify creation
- Look for the lead ID in contact custom properties
- Verify deal is linked to the contact

### 6) Troubleshooting
- If contacts/deals aren't created: verify `crm_enabled` and `hubspot_api_key` are TRUE
- Check n8n execution logs for errors around HubSpot nodes
- Ensure your HubSpot Private App has correct permissions
- Verify the API token is valid and not expired
- Check that custom properties (`lead_id`, `lead_priority`, `lead_score`, `lead_source`) exist in your HubSpot account
