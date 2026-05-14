---
title: Event Tracking
type: docs
prev: docs/primitives
next: docs/primitives/sessions
---

## What is an Event?

An **event** is a record of a single, meaningful action that occurred in your application — typically tied to an HTTP request. Think of it as answering the question: _"who did what, when, and how?"_

Events are the highest-volume primitive. You would create one for every significant operation your application handles: a user logging in, a file being uploaded, an order being placed, a webhook being received.

**Examples:**

| Action             | Trigger                           |
| ------------------ | --------------------------------- |
| `user.login`       | A user authenticates successfully |
| `invoice.created`  | A new invoice is generated        |
| `password.reset`   | A password reset is completed     |
| `api_key.revoked`  | An API key is deleted             |
| `export.requested` | A user requests a data export     |

Each event carries the HTTP context (method, status, endpoint), the client's IP and user agent, and any arbitrary metadata you attach — making it straightforward to reconstruct exactly what happened during a given request.

---

## Fields

Captures HTTP activity across your application. Each event records:

- Action name (e.g. `user.login`, `invoice.created`)
- HTTP method, status code, and endpoint
- Client IP address and user agent
- Geolocation derived from IP
- User identity (username / user ID)
- Arbitrary JSON metadata

Useful for tracking every meaningful interaction a user or service has with your system.

{{< tabs items="Go,PHP,TypeScript,cURL" >}}
{{< tab >}}

```go
import (
    "context"
    logtrace "github.com/logtracehq/logtrace-go"
)

client := logtrace.New(os.Getenv("LOGTRACE_API_KEY"))

client.CreateEvent(context.Background(), &logtrace.CreateEventRequest{
    ActionName:      "user.login",
    HTTPMethod:      "POST",
    HTTPStatus:      "200",
    Endpoint:        "/auth/login",
    ClientIP:        "203.0.113.42",
    ClientUserAgent: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)",
    UserID:          "user_123",
    Username:        "jane.doe",
    Metadata:        map[string]any{"plan": "pro", "source": "web"},
})
```

{{< /tab >}}
{{< tab >}}

```php
use Logtrace\Logtrace;
require 'vendor/autoload.php';

$client = new Logtrace(getenv('LOGTRACE_API_KEY'));

$client->createEvent([
    'action_name'       => 'user.login',
    'http_method'       => 'POST',
    'http_status'       => '200',
    'endpoint'          => '/auth/login',
    'client_ip'         => '203.0.113.42',
    'client_user_agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)',
    'user_id'           => 'user_123',
    'username'          => 'jane.doe',
    'metadata'          => ['plan' => 'pro', 'source' => 'web'],
]);
```

{{< /tab >}}
{{< tab >}}

```typescript
import { Logtrace } from "logtrace-ts";

const client = new Logtrace(process.env.LOGTRACE_API_KEY);

await client.createEvent({
  action_name: "user.login",
  http_method: "POST",
  http_status: "200",
  endpoint: "/auth/login",
  client_ip: "203.0.113.42",
  client_user_agent: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)",
  user_id: "user_123",
  username: "jane.doe",
  metadata: { plan: "pro", source: "web" },
});
```

{{< /tab >}}
{{< tab >}}

```bash
curl -X POST https://api.logtracehq.com/v1/events \
  -H "Authorization: Bearer $LOGTRACE_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "action_name": "user.login",
    "http_method": "POST",
    "http_status": "200",
    "endpoint": "/auth/login",
    "client_ip": "203.0.113.42",
    "client_user_agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)",
    "user_id": "user_123",
    "username": "jane.doe",
    "metadata": { "plan": "pro", "source": "web" }
  }'
```

{{< /tab >}}
{{< /tabs >}}
