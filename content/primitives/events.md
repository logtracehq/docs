---
title: Event Tracking
type: docs
prev: primitives
next: primitives/sessions
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
package main

import (
	"log"
	"net/http"
	"os"

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

		_, err := lc.CreateEvent(r.Context(), &logtrace.CreateEventRequest{
			ActionName: "user.login",
			UserID:     "12345",
			UserName:   "jane_doe",
			Type:       "user event",
			Metadata: logtrace.Metadata{
				"action":      "login",
				"type":        "user",
				"description": "User logged in successfully",
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
