---
title: Changelog
type: docs
prev: sdks/php
---

Track notable documentation and product updates here.

## v0.1.1 — May 11, 2026

### Added

- All SDKs expose the same three core primitives: event tracking, session logging, and audit logs.

- **Go SDK** (`github.com/logtracehq/logtrace-go`) — official Go client with support for `CreateEvent`, `CreateSession`, and `CreateAuditLog`.

- **TypeScript SDK** (`logtrace-ts`) — official TypeScript/Node.js client with full async/await support for all three primitives.
- **Python SDK** (`logtrace-py`) — zero external dependencies. Supports `create_event`, `create_session`, and `create_audit_log`.
- **PHP SDK** (`logtracehq/logtrace-php`) — Composer package exposing `createEvent`, `createSession`, and `createAuditLog`.

## Format

This project follows a Keep a Changelog style:

- `Added` for new features.
- `Changed` for changes in existing functionality.
- `Deprecated` for soon-to-be removed features.
- `Removed` for now removed features.
- `Fixed` for any bug fixes.
- `Security` to invite users to upgrade in case of vulnerabilities.
