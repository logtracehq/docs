---
title: Go SDK
type: docs
prev: docs/sdks
next: docs/sdks/typescript
---

## Install

```bash
go get github.com/logtracehq/logtrace-go
```

## Usage

```go
import (
    "context"
    "os"
    "time"
    logtrace "github.com/logtracehq/logtrace-go"
)

client := logtrace.New(os.Getenv("LOGTRACE_API_KEY"))

// Track an event
client.CreateEvent(context.Background(), &logtrace.CreateEventRequest{
    ActionName:      "user_signup",
    UserID:          "user_123",
    HTTPMethod:      "POST",
    HTTPStatus:      "200",
    ClientIP:        "192.168.1.1",
    ClientUserAgent: "Mozilla/5.0",
})

// Create a session
client.CreateSession(context.Background(), &logtrace.CreateSessionRequest{
    LoginAt:    time.Now(),
    Status:     "ACTIVE",
    UserID:     "user_123",
    IPAddress:  "192.168.1.1",
    DeviceInfo: "Chrome on macOS",
})

// Create an audit log
client.CreateAuditLog(context.Background(), &logtrace.CreateAuditLogRequest{
    Action:    "user.signup",
    Timestamp: "2024-01-15T10:30:00Z",
    UserID:    "user_123",
    Metadata:  map[string]any{"plan": "pro", "source": "web"},
})
```
