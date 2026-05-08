---
title: TypeScript SDK
type: docs
prev: docs/sdks/go
next: docs/sdks/python
---

## Install

```bash
npm install logtrace-ts
```

## Usage

```typescript
import { Logtrace } from "logtrace-ts";

const client = new Logtrace(process.env.LOGTRACE_API_KEY);

// Track an event
await client.createEvent({
  action_name: "user_signup",
  user_id: "user_123",
  http_method: "POST",
  http_status: "200",
  client_ip: "192.168.1.1",
  client_user_agent: req.headers["user-agent"],
});

// Create a session
await client.createSession({
  login_at: new Date().toISOString(),
  status: "ACTIVE",
  user_id: "user_123",
  ip_address: "192.168.1.1",
  device_info: "Chrome on macOS",
});

// Create an audit log
await client.createAuditLog({
  action: "user.signup",
  timestamp: new Date().toISOString(),
  user_id: "user_123",
  metadata: { plan: "pro", source: "web" },
});
```
