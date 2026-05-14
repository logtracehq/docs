---
title: Audit Logs
type: docs
prev: docs/primitives/sessions
next: docs/architecture
---

## What is an Audit Log?

An **audit log** is an explicit, immutable record that something consequential happened — independent of any HTTP request. Where events are tied to the request/response cycle, audit logs are for actions that matter for compliance, accountability, or debugging, regardless of how they were triggered.

Think of audit logs as answering: _"what changed, who changed it, and what did it look like before and after?"_

**Examples:**

| Action                   | Context                                              |
| ------------------------ | ---------------------------------------------------- |
| `invoice.deleted`        | Billing record removed, before/after status captured |
| `user.role_changed`      | Privilege escalation, old and new role recorded      |
| `config.updated`         | System setting modified, diff stored in metadata     |
| `data.exported`          | Sensitive records accessed for export                |
| `subscription.cancelled` | Plan change with reason stored in metadata           |

Audit logs are the right primitive when you need a tamper-evident trail for regulators, security reviews, or customer-facing activity logs. The `metadata` field accepts arbitrary JSON, making it easy to store before/after diffs, resource identifiers, or any other context relevant to the action.

---

## Fields

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
