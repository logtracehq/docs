---
title: Logtrace Documentation
type: docs
next: docs/primitives
---

## What is Logtrace?

Logtrace is a secure audit trail and logging platform built for compliance and security. It gives developers and organizations a simple API to capture, store, and query records of everything that happens in their systems — who did what, when, from where, and how.

Logtrace is designed for multi-tenant SaaS products and is compliance-ready out of the box, targeting frameworks such as **SOC 2**, **GDPR**, and **HIPAA**.

---

## What Logtrace Covers

Logtrace provides three core logging primitives that together form a complete audit trail for your application.

### Event Tracking

Captures HTTP activity across your application. Each event records:

- Action name (e.g. `user.login`, `invoice.created`)
- HTTP method, status code, and endpoint
- Client IP address and user agent
- Geolocation derived from IP
- User identity (username / user ID)
- Arbitrary JSON metadata

Useful for tracking every meaningful interaction a user or service has with your system.

### Session Logging

Records user login and logout events enriched with device information, IP address, and location. Sessions carry a status (`ACTIVE` / `INACTIVE`), making it easy to audit access history and detect anomalous activity.

### Audit Logs

Explicit, structured audit trail entries designed for compliance use cases. Each audit log entry includes:

- Action name and timestamp
- User identity and IP address
- Arbitrary JSON metadata (e.g. before/after values, resource identifiers)

Suitable for representing anything from a database query to a configuration change to a billing action.

---

## Architecture

- **Multi-tenant**: All data is scoped to an organization, giving each customer or team a fully isolated, searchable audit trail.
- **RESTful API**: Comprehensive API for log ingestion, user administration, and system monitoring.
- **JWT Authentication**: Secure token-based authentication with optional OAuth integration.
- **PostgreSQL backend**: Robust storage with schema migrations managed via `golang-migrate`.
- **Pagination and filtering**: All list endpoints support date range filtering, search, and cursor-based pagination.

---

## Available SDKs

Official SDKs are available for four languages. Each SDK exposes the same three primitives: `createEvent`, `createSession`, and `createAuditLog`.

### Go

```bash
go get github.com/logtracehq/logtrace-go
```

```go
import logtrace "github.com/logtracehq/logtrace-go"

client := logtrace.New("your-api-key")

client.CreateEvent(ctx, &logtrace.CreateEventRequest{
    ActionName: "user.login",
    Username:   "jane_doe",
    HTTPMethod: "POST",
    HTTPStatus: "200",
    ClientIP:   "192.168.1.1",
})

client.CreateSession(ctx, &logtrace.CreateSessionRequest{
    LoginAt:  time.Now(),
    Status:   "ACTIVE",
    Username: "jane_doe",
})

client.CreateAuditLog(ctx, &logtrace.CreateAuditLogRequest{
    Action:    "user.deleted",
    Timestamp: time.Now().Format(time.RFC3339),
    Username:  "jane_doe",
    Metadata: &logtrace.Metadata{
        Event:       "deletion",
        Type:        "user",
        Description: "User account was deleted",
    },
})
```

### TypeScript / JavaScript

```bash
npm install logtrace-sdk
```

```typescript
import { Logtrace } from "logtrace-sdk";

const client = new Logtrace("your-api-key");

await client.createEvent({
  action_name: "user.login",
  username: "jane_doe",
  http_method: "POST",
  http_status: "200",
  client_ip: "192.168.1.1",
});

await client.createSession({
  login_at: new Date().toISOString(),
  status: "ACTIVE",
  username: "jane_doe",
});

await client.createAuditLog({
  action: "user.deleted",
  timestamp: new Date().toISOString(),
  username: "jane_doe",
  metadata: {
    event: "deletion",
    type: "user",
    description: "User account was deleted",
  },
});
```

### Python

Zero external dependencies.

```bash
pip install logtrace-sdk
```

```python
from logtrace import Logtrace, CreateEventRequest, CreateSessionRequest, CreateAuditLogRequest, AuditLogMetadata
from datetime import datetime, timezone

client = Logtrace("your-api-key")

client.create_event(CreateEventRequest(
    action_name="user.login",
    username="jane_doe",
    http_method="POST",
    http_status="200",
    client_ip="192.168.1.1",
))

client.create_session(CreateSessionRequest(
    login_at=datetime.now(timezone.utc).isoformat(),
    status="ACTIVE",
    username="jane_doe",
))

client.create_audit_log(CreateAuditLogRequest(
    action="user.deleted",
    timestamp=datetime.now(timezone.utc).isoformat(),
    username="jane_doe",
    metadata=AuditLogMetadata(event="deletion", type="user", description="User account was deleted"),
))
```

### PHP

```bash
composer require logtracehq/logtrace-sdk
```

```php
use Logtrace\Logtrace;

$client = new Logtrace('your-api-key');

$client->createEvent([
    'action_name'  => 'user.login',
    'username'     => 'jane_doe',
    'http_method'  => 'POST',
    'http_status'  => '200',
    'client_ip'    => '192.168.1.1',
]);

$client->createSession([
    'login_at' => date('c'),
    'status'   => 'ACTIVE',
    'username' => 'jane_doe',
]);

$client->createAuditLog([
    'action'    => 'user.deleted',
    'timestamp' => date('c'),
    'username'  => 'jane_doe',
    'metadata'  => ['event' => 'deletion', 'type' => 'user', 'description' => 'User account was deleted'],
]);
```

You can also point the PHP client at a self-hosted instance:

```php
$client = new Logtrace('your-api-key', 'https://your-instance.com/v1/developers');
```
