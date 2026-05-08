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

## Session Logging

Records user login and logout events enriched with device information, IP address, and location. Sessions carry a status (`ACTIVE` / `INACTIVE`), making it easy to audit access history and detect anomalous activity.

## Audit Logs

Explicit, structured audit trail entries designed for compliance use cases. Each audit log entry includes:

- Action name and timestamp
- User identity and IP address
- Arbitrary JSON metadata (e.g. before/after values, resource identifiers)

Suitable for representing anything from a database query to a configuration change to a billing action.
