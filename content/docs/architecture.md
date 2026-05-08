---
title: Architecture
type: docs
prev: docs/primitives
next: docs/sdks
---

## Overview

Logtrace is built on a multi-tenant architecture where all data is scoped to an **organization**. Each customer or team gets a fully isolated, searchable audit trail with no data leakage between tenants.

## Key Design Decisions

- **Multi-tenant**: Organization-based access control with role-based permissions. Users can belong to multiple organizations.
- **RESTful API**: Comprehensive API for log ingestion, user administration, and system monitoring.
- **Authentication**: Two authentication modes — session-based auth for dashboard users (email/password or OAuth via Google) and API key-based auth for programmatic access via the developer endpoints.
- **PostgreSQL backend**: Robust storage with schema migrations managed via `golang-migrate`.
- **Pagination and filtering**: All list endpoints support date-range filtering, full-text search, and cursor-based pagination.

## Tech Stack

| Layer         | Technology                       |
| ------------- | -------------------------------- |
| Backend       | Go                               |
| Database      | PostgreSQL                       |
| Migrations    | golang-migrate                   |
| Frontend      | React + TypeScript (Vite)        |
| Auth          | Session (email/OAuth) + API keys |
| Observability | OpenTelemetry (otel)             |
