---
title: Session Logging
type: docs
prev: primitives/events
next: primitives/audit-logs
---

## What is a Session?

A **session** is a record of a user's authenticated presence in your application — from login to logout (or expiry). Where events capture individual actions, a session captures the _span_ of a user's access.

Sessions are useful for answering questions like: _"Where did this user log in from? What device were they using? How long were they active?"_

**Examples:**

| Scenario                            | Status     |
| ----------------------------------- | ---------- |
| User signs in from a new device     | `ACTIVE`   |
| User explicitly logs out            | `INACTIVE` |
| Session expires after inactivity    | `INACTIVE` |
| Admin remotely terminates a session | `INACTIVE` |

Each session is enriched with the client's IP address and device information, and geolocation is derived automatically from the IP. This makes sessions particularly useful for detecting account takeovers, concurrent logins from different locations, or suspicious access patterns.

---

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
