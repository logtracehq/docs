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

Logtrace provides three core logging primitives — **Event Tracking**, **Session Logging**, and **Audit Logs** — that together form a complete audit trail for your application.

→ [Learn about the primitives](docs/primitives)

---

## Architecture

Logtrace is built on a multi-tenant architecture where all data is scoped to an organization. It exposes a RESTful API with API key and session-based authentication, backed by PostgreSQL with cursor-based pagination and date-range filtering.

→ [Read about the architecture](docs/architecture)

---

## Available SDKs

Official SDKs are available for Go, TypeScript, Python, and PHP. Each SDK exposes the same three primitives: `createEvent`, `createSession`, and `createAuditLog`.

→ [Browse the SDKs](docs/sdks)
