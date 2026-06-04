---
title: Node.js SDK
type: docs
prev: sdks/go
next: sdks/python
---

## Install

```bash
npm install @logtracehq/logtrace-node
```

## Usage

```ts
import { Logtrace } from "@logtracehq/logtrace-node";

const client = Logtrace.new(process.env.LOGTRACE_API_KEY!);

// Track an application event
await client.createEvent({
  actionName: "invoice.created",
  userId: "user_123",
  userName: "jane.doe",
  metadata: {
    invoiceId: "inv_456",
    amount: 250000,
    currency: "UGX",
  },
});

// Track a user session
await client.createSession({
  userId: "user_123",
  loginAt: new Date(),
  status: "active",
});

// Create an audit log entry
await client.createAuditLog({
  action: "user.updated",
  timestamp: new Date(),
  userId: "user_123",
  userName: "jane.doe",
  metadata: {
    role: {
      old: "user",
      new: "admin",
    },
  },
});
```

## Express middleware example

Automatically attaches request context (IP, method, endpoint, headers, status code) to every Logtrace call made inside a request handler.

```ts
import express from "express";
import { Logtrace, logger, fromContext } from "@logtracehq/logtrace-node";

const app = express();

const client = Logtrace.new(process.env.LOGTRACE_API_KEY!);

app.use(logger(client));

app.post("/login", async (req, res) => {
  const logtrace = fromContext(client);

  await logtrace.createSession({
    userId: "user_123",
    loginAt: new Date(),
    status: "active",
  });

  await logtrace.createEvent({
    actionName: "user.login",
    userName: "jane.doe",
    userId: "user_123",
  });

  res.json({ ok: true });
});
```

`fromContext()` automatically enriches records with request metadata when available and falls back gracefully outside HTTP contexts (workers, cron jobs, queues, and tests).

## Background jobs

```ts
import { Logtrace } from "@logtracehq/logtrace-node";

const client = Logtrace.new(process.env.LOGTRACE_API_KEY!);

async function processInvoice(invoiceId: string) {
  await client.createEvent({
    eventName: "invoice.processing.started",
    source: "invoice-worker",
    metadata: {
      invoiceId,
    },
  });

  // process invoice...

  await client.createEvent({
    eventName: "invoice.processing.completed",
    source: "invoice-worker",
    metadata: {
      invoiceId,
    },
  });
}
```

## Error handling

```ts
import { Logtrace, LogtraceError } from "@logtracehq/logtrace-node";

const client = Logtrace.new(process.env.LOGTRACE_API_KEY!);

try {
  await client.createEvent({
    eventName: "user.created",
    source: "api",
  });
} catch (err) {
  if (err instanceof LogtraceError) {
    console.error("Logtrace API error:", {
      statusCode: err.statusCode,
      message: err.message,
    });
  } else {
    console.error("Unexpected error:", err);
  }
}
```
