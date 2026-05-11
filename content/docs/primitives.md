---
title: Logging Primitives
type: docs
prev: docs/
next: docs/architecture
---

Logtrace provides three core logging primitives that together form a complete audit trail for your application.

## Event Tracking

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

## Session Logging

Records user login and logout events enriched with device information, IP address, and location. Sessions carry a status (`ACTIVE` / `INACTIVE`), making it easy to audit access history and detect anomalous activity.

{{< tabs items="Go,PHP,TypeScript,cURL" >}}
{{< tab >}}

```go
import (
    "context"
    "time"
    logtrace "github.com/logtracehq/logtrace-go"
)

client := logtrace.New(os.Getenv("LOGTRACE_API_KEY"))

client.CreateSession(context.Background(), &logtrace.CreateSessionRequest{
    LoginAt:    time.Now(),
    Status:     "ACTIVE",
    UserID:     "user_123",
    IPAddress:  "203.0.113.42",
    DeviceInfo: "Chrome 120 on macOS",
})
```

{{< /tab >}}
{{< tab >}}

```php
use Logtrace\Logtrace;
require 'vendor/autoload.php';

$client = new Logtrace(getenv('LOGTRACE_API_KEY'));

$client->createSession([
    'login_at'    => date('c'),
    'status'      => 'ACTIVE',
    'user_id'     => 'user_123',
    'ip_address'  => '203.0.113.42',
    'device_info' => 'Chrome 120 on macOS',
]);
```

{{< /tab >}}
{{< tab >}}

```typescript
import { Logtrace } from "logtrace-ts";

const client = new Logtrace(process.env.LOGTRACE_API_KEY);

await client.createSession({
  login_at: new Date().toISOString(),
  status: "ACTIVE",
  user_id: "user_123",
  ip_address: "203.0.113.42",
  device_info: "Chrome 120 on macOS",
});
```

{{< /tab >}}
{{< tab >}}

```bash
curl -X POST https://api.logtracehq.com/v1/sessions \
  -H "Authorization: Bearer $LOGTRACE_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "login_at": "2024-01-15T10:30:00Z",
    "status": "ACTIVE",
    "user_id": "user_123",
    "ip_address": "203.0.113.42",
    "device_info": "Chrome 120 on macOS"
  }'
```

{{< /tab >}}
{{< /tabs >}}

## Audit Logs

Explicit, structured audit trail entries designed for compliance use cases. Each audit log entry includes:

- Action name and timestamp
- User identity and IP address
- Arbitrary JSON metadata (e.g. before/after values, resource identifiers)

Suitable for representing anything from a database query to a configuration change to a billing action.

{{< tabs items="Go,PHP,TypeScript,cURL" >}}
{{< tab >}}

```go
import (
    "context"
    logtrace "github.com/logtracehq/logtrace-go"
)

client := logtrace.New(os.Getenv("LOGTRACE_API_KEY"))

client.CreateAuditLog(context.Background(), &logtrace.CreateAuditLogRequest{
    Action:    "invoice.deleted",
    Timestamp: "2024-01-15T10:30:00Z",
    UserID:    "user_123",
    IPAddress: "203.0.113.42",
    Metadata:  map[string]any{
        "invoice_id": "inv_456",
        "amount":     9900,
        "before":     map[string]any{"status": "active"},
        "after":      map[string]any{"status": "deleted"},
    },
})
```

{{< /tab >}}
{{< tab >}}

```php
use Logtrace\Logtrace;
require 'vendor/autoload.php';

$client = new Logtrace(getenv('LOGTRACE_API_KEY'));

$client->createAuditLog([
    'action'     => 'invoice.deleted',
    'timestamp'  => '2024-01-15T10:30:00Z',
    'user_id'    => 'user_123',
    'ip_address' => '203.0.113.42',
    'metadata'   => [
        'invoice_id' => 'inv_456',
        'amount'     => 9900,
        'before'     => ['status' => 'active'],
        'after'      => ['status' => 'deleted'],
    ],
]);
```

{{< /tab >}}
{{< tab >}}

```typescript
import { Logtrace } from "logtrace-ts";

const client = new Logtrace(process.env.LOGTRACE_API_KEY);

await client.createAuditLog({
  action: "invoice.deleted",
  timestamp: "2024-01-15T10:30:00Z",
  user_id: "user_123",
  ip_address: "203.0.113.42",
  metadata: {
    invoice_id: "inv_456",
    amount: 9900,
    before: { status: "active" },
    after: { status: "deleted" },
  },
});
```

{{< /tab >}}
{{< tab >}}

```bash
curl -X POST https://api.logtracehq.com/v1/audit-logs \
  -H "Authorization: Bearer $LOGTRACE_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "action": "invoice.deleted",
    "timestamp": "2024-01-15T10:30:00Z",
    "user_id": "user_123",
    "ip_address": "203.0.113.42",
    "metadata": {
      "invoice_id": "inv_456",
      "amount": 9900,
      "before": { "status": "active" },
      "after": { "status": "deleted" }
    }
  }'
```

{{< /tab >}}
{{< /tabs >}}
