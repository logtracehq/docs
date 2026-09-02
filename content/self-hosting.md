---
title: Self-host Logtrace
type: docs
prev: /
next: primitives
sidebar:
  open: true
---

Run Logtrace on your own infrastructure with the Go API, PostgreSQL, Redis, and the React web application.

## Architecture

The Logtrace backend serves the API on port `8080`. It stores application data in PostgreSQL and uses Redis for caching and background email work. The frontend is a static Vite build and can be served by any web server.

```text
Browser -> Web server -> Logtrace frontend
                    -> Logtrace API -> PostgreSQL
                                   -> Redis
```

Keep PostgreSQL and Redis on a private network. Expose only the frontend and API through your reverse proxy.

## Requirements

- Node.js 22 or newer and npm
- Go 1.25 or newer
- PostgreSQL with the `uuid-ossp` extension available
- Redis 7 or newer
- A public HTTPS hostname for the frontend and API in production
- An AWS SES identity and credentials for verification, invitation, and password-reset email

Clone the source and work from the repository root. The backend is in `backend/` and the frontend is in `app/`.

## Configure the backend

The backend reads configuration from environment variables prefixed with `LOGTRACE_`. Nested settings use underscores, for example `LOGTRACE_DATABASE_POSTGRES_DSN` and `LOGTRACE_AUTH_JWT_KEY`.

Create a private environment file for the backend. These are the minimum settings for a production installation:

```dotenv
LOGTRACE_ENV=production
LOGTRACE_HTTP_PORT=8080
LOGTRACE_DATABASE_POSTGRES_DSN=postgres://logtrace:<password>@postgres:5432/logtrace?sslmode=require
LOGTRACE_DATABASE_REDIS_DSN=redis://redis:6379/0
LOGTRACE_FRONTEND_APP_URL=https://logtrace.example.com

LOGTRACE_AUTH_JWT_KEY=<long-random-secret>
LOGTRACE_CSRF_SECRET=<long-random-secret>
LOGTRACE_API_KEY_HASH_SECRET=<long-random-secret>

LOGTRACE_EMAIL_SENDER=Logtrace <noreply@example.com>
LOGTRACE_EMAIL_SENDER_NAME=Logtrace
LOGTRACE_EMAIL_SES_REGION=us-east-1
LOGTRACE_EMAIL_SES_ACCESS_KEY=<aws-access-key>
LOGTRACE_EMAIL_SES_SECRET_KEY=<aws-secret-key>

LOGTRACE_AUTH_GOOGLE_CLIENT_ID=<google-client-id>
LOGTRACE_AUTH_GOOGLE_CLIENT_SECRET=<google-client-secret>
LOGTRACE_AUTH_GOOGLE_REDIRECT_URL=https://api.example.com/auth/connect/google
```

Use a secrets manager or your deployment platform's secret storage instead of committing this file. Generate secrets with a cryptographically secure tool, for example:

```bash
openssl rand -hex 32
```

The current backend validates Google OAuth settings during startup, so provide valid values even if you do not immediately enable Google sign-in. Configure the Google OAuth consent screen with the API redirect URL shown above.

The backend uses AWS SES directly. Verify the sender identity in SES and make sure the AWS principal can call `ses:SendEmail`. SES sandbox accounts can send only to verified recipients.

Optional settings include rate limiting, metrics, OpenTelemetry, S3 uploads, and billing trial length. See `backend/config/.env.example` for the complete list of supported names.

## Start PostgreSQL and Redis

Create a database and user, then make sure the database is reachable using the DSN in your backend environment. For a local dependency stack, Docker can run both services:

```bash
docker network create logtrace-internal

docker run -d --name logtrace-postgres \
  --network logtrace-internal \
  -e POSTGRES_DB=logtrace \
  -e POSTGRES_USER=logtrace \
  -e POSTGRES_PASSWORD='<password>' \
  -v logtrace-postgres:/var/lib/postgresql/data \
  postgres:16

docker run -d --name logtrace-redis \
  --network logtrace-internal \
  -v logtrace-redis:/data \
  redis:7-alpine
```

For production, use managed or separately maintained PostgreSQL and Redis services with backups, monitoring, and access controls.

## Run the backend

The HTTP service applies pending database migrations when it starts. From `backend/`, export the environment variables and run:

```bash
go mod download
go run ./cmd/main.go http
```

To build a production binary instead:

```bash
go build -o logtrace ./cmd/main.go
./logtrace http
```

The API should now be reachable at `http://localhost:8080`. Do not expose the database or Redis ports publicly.

If you need to run migrations separately, use the migration directory in this repository:

```bash
go run ./cmd/migrate/main.go \
  -path ./internal/datastore/postgres/migrations \
  -action up
```

## Build and serve the frontend

Frontend environment variables are embedded into the static bundle at build time. Set `VITE_API_URL` to the public API origin before building:

```bash
cd app
npm ci
VITE_API_URL=https://api.example.com npm run build
```

Serve the generated `app/dist/` directory with your web server. Configure the web server to fall back to `index.html` for client-side routes. The frontend does not need access to PostgreSQL or Redis.

For local development, create `app/.env.local` instead:

```dotenv
VITE_API_URL=http://localhost:8080
```

Then run `npm run dev`.

## Reverse proxy and URLs

Use HTTPS for both origins and configure your reverse proxy to:

- serve the frontend at `https://logtrace.example.com`;
- proxy `https://api.example.com` to the backend's port `8080`;
- preserve the `Host`, `X-Forwarded-For`, and `X-Forwarded-Proto` headers;
- allow request bodies large enough for your logging payloads;
- redirect HTTP to HTTPS.

Set `LOGTRACE_FRONTEND_APP_URL` to the exact frontend origin, without a trailing path. Set `VITE_API_URL` to the exact API origin used by browsers. The two values must point to the same installation.

## Docker builds

The repository includes Dockerfiles for both services. Build the backend from `backend/` and inject the backend environment at runtime. Build the frontend after providing its `VITE_API_URL`; because Vite embeds it into the bundle, changing it requires a new frontend build.

```bash
docker build -t logtrace-backend ./backend
docker run --rm --env-file backend/.env -p 8080:8080 logtrace-backend

docker build -t logtrace-frontend ./app
docker run --rm -p 5173:5173 logtrace-frontend
```

The frontend Dockerfile runs its build during `docker build`, so place the desired `VITE_API_URL` in an environment file available to the build context or build the static bundle directly with npm. Do not bake backend secrets into the frontend image.

## First login and upgrades

After the API and frontend are online, open the frontend URL and create the first account. Use an API key from the dashboard with one of the official SDKs to send events, sessions, and audit logs.

For upgrades, deploy the new backend version and let its startup migration step complete before directing traffic to it. Back up PostgreSQL before upgrades, review migration status and application logs, and rebuild the frontend for every release.

## Production checklist

- Replace every development secret and default credential.
- Store secrets outside Git and restrict access to the backend process.
- Enable PostgreSQL backups and test restoration.
- Restrict PostgreSQL and Redis to private networks.
- Use HTTPS and verify the frontend/API origins.
- Verify the SES sender and required IAM permissions.
- Enable rate limiting and monitoring for your traffic profile.
- Keep the frontend and backend on compatible releases.
