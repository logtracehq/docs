---
title: Audit Logs
type: docs
prev: primitives/sessions
next: architecture
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

{{< tabs items="Go,PHP,Node.js,cURL" >}}
{{< tab >}}

```go

package main

import (
	"log"
	"net/http"
	"os"
	"time"

	_ "github.com/joho/godotenv/autoload"

	logtrace "github.com/logtracehq/logtrace-go"
)

func main() {
	client, err := logtrace.New(os.Getenv("API_KEY"))
	if err != nil {
		log.Fatalf("Failed to create LogTrace client: %v", err)
	}

	mux := http.NewServeMux()
	mux.HandleFunc("/run", func(w http.ResponseWriter, r *http.Request) {
		lc := logtrace.FromContext(r.Context(), client)

		// Create an audit log
		_, err = lc.CreateAuditLog(r.Context(), &logtrace.CreateAuditLogRequest{
			Action:    "user.deleted",
			Timestamp: time.Now().Format(time.RFC3339),
			UserName:  "jane_doe",
			Metadata: logtrace.Metadata{
				"action":      "deletion",
				"type":        "user",
				"description": "User account was deleted",
			},
		})
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		w.WriteHeader(http.StatusOK)
		w.Write([]byte("done"))
	})

	log.Fatal(http.ListenAndServe(":5000", logtrace.Logger(client)(mux)))
}

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
import { Logtrace } from "@logtracehq/logtrace-node";

const client = new Logtrace(process.env.LOGTRACE_API_KEY);

await client.createAuditLog({
  action: "invoice.deleted",
  timestamp: "2024-01-15T10:30:00Z",
  user_id: "user_123",
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
