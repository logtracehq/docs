---
title: Logtrace Documentation
type: docs
next: primitives
---

## What is Logtrace?

Logtrace is a secure audit trail and logging platform built for compliance and security. It gives developers and organizations a simple API to capture, store, and query records of everything that happens in their systems — who did what, when, from where, and how.

Logtrace is designed for multi-tenant SaaS products and appications (web or mobile) and is compliance-ready out of the box, targeting frameworks such as **SOC 2**, **GDPR**, and **HIPAA**.

---

## What Logtrace Covers

Logtrace provides three core logging primitives — **Event Tracking**, **Session Logging**, and **Audit Logs** — that together form a complete audit trail for your application.

[Learn about the Logtrace primitives](primitives) ⟶

---

## Available SDKs

Official SDKs are available for Go, TypeScript, Python, and PHP. Each SDK exposes the same three primitives: `createEvent`, `createSession`, and `createAuditLog`.

{{< cards >}}
{{< card link="sdks/go" title="Go" icon="code" >}}
{{< card link="sdks/node" title="Node.js" icon="code" >}}
{{< card link="sdks/python" title="Python" icon="code" >}}
{{< card link="sdks/php" title="PHP" icon="code" >}}
{{< /cards >}}
