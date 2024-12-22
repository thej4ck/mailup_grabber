# Pipedrive MailUp Integration

This service integrates MailUp email campaign statistics with Pipedrive CRM, providing a custom panel to display email engagement metrics directly in the Pipedrive person detail view.

## Features

- Displays the last 10 email campaigns statistics for a Pipedrive contact
- Shows email views and clicks metrics
- Provides email content preview
- Caches message details to improve performance
- Uses color-coded tags to indicate engagement levels:
  - Red: No views or clicks
  - Yellow: Views but no clicks
  - Blue: Has clicks

## Prerequisites

- Node.js and npm installed
- Access to MailUp API (Client ID and Secret)
- MailUp account credentials
- Pipedrive account with admin access
- [Pipedrive Forward Auth Service](https://github.com/thej4ck/pipedrive-forward-auth) running

## Environment Variables

```env
MAILUP_CLIENT_ID=your_mailup_client_id
MAILUP_CLIENT_SECRET=your_mailup_client_secret
MAILUP_USERNAME=your_mailup_username
MAILUP_PASSWORD=your_mailup_password
WEBHOOK_BASE_PATH=webhook/person/detail/
FORWARD_AUTH_URL=http://forward-auth:4000
BASIC_AUTH_USER=your_basic_auth_username
BASIC_AUTH_PASS=your_basic_auth_password
MAX_FIELD_LENGTH=40
PORT=3000
```

## Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   npm install
   ```
3. Set up environment variables
4. Start the service:
   ```bash
   npm start
   ```

## Pipedrive Setup

1. Create a new custom panel in Pipedrive person details view
2. Configure the panel with the following JSON schema:
```json
{
  "type": "array",
  "items": {
    "type": "object",
    "required": [
      "id",
      "header"
    ],
    "properties": {
      "id": {
        "$ref": "#/definitions/numerical"
      },
      "header": {
        "$ref": "#/definitions/header"
      },
      "title": {
        "$ref": "#/definitions/text",
        "label": "Oggetto Email"
      },
      "views": {
        "$ref": "#/definitions/label"
      },
      "clicks": {
        "$ref": "#/definitions/label"
      },
      "Anteprima": {
        "$ref": "#/definitions/text",
        "label": "Anteprima"
      }
    }
  }
}
```

3. Set the panel's data source URL to your deployed service endpoint

## API Endpoints

### GET /{WEBHOOK_BASE_PATH}

Endpoint for Pipedrive webhook integration. Requires basic authentication.

**Query Parameters:**
- `resource`: Must be "person"
- `view`: Must be "details"
- `userId`: Pipedrive user ID
- `companyId`: Pipedrive company ID
- `selectedIds`: Selected person ID

**Response Format:**
```json
{
  "data": [
    {
      "id": "message_id",
      "header": "email_subject",
      "title": "email_subject",
      "views": "view_count",
      "clicks": "click_count",
      "tag": {
        "color": "status_color",
        "label": "V{views}C{clicks}"
      },
      "Anteprima": {
        "markdown": true,
        "value": "email_content_preview"
      }
    }
  ]
}
```

## Features

### Message Caching
The service implements caching for message details to improve performance and reduce API calls to MailUp.

### HTML Content Cleaning
Email content is cleaned and processed before display:
- Removes HTML tags while preserving text
- Converts common HTML entities
- Truncates content to configured maximum length

### Rate Limiting
Includes a 200ms delay between MailUp API calls to respect rate limits.

## Dependencies

- express: Web server framework
- axios: HTTP client
- qs: Query string parsing
- express-basic-auth: Basic authentication middleware

## Error Handling

The service includes comprehensive error handling and logging:
- Token expiration and refresh
- API call failures
- Invalid request parameters
- Missing credentials

## Security

- Basic authentication required for all webhook endpoints
- Environment variables for sensitive credentials
- Integration with Pipedrive Forward Auth service for token management

## Logging

Detailed logging system that includes:
- Timestamp
- Context
- Message
- Optional data object (when relevant)

## Contributing

Please read our contributing guidelines before submitting pull requests.

## License

This project is licensed under the MIT License - see the LICENSE file for details.