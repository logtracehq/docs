---
title: Python SDK
type: docs
prev: sdks/typescript
next: sdks/php
description: Official Python SDK for Logtrace. Zero external dependencies.
---

Zero external dependencies.

## Install

```bash
pip install logtrace-py
```

## Usage

```python
from logtrace import Logtrace, CreateEventRequest, CreateSessionRequest, CreateAuditLogRequest
import os

client = Logtrace(api_key=os.environ['LOGTRACE_API_KEY'])

# Track an event
client.create_event(CreateEventRequest(
    action_name='user_signup',
    user_id='user_123',
    http_method='POST',
    http_status='200',
    client_ip='192.168.1.1',
    client_user_agent='Mozilla/5.0'
))

# Create a session
client.create_session(CreateSessionRequest(
    login_at='2024-01-15T10:30:00Z',
    status='ACTIVE',
    user_id='user_123',
    ip_address='192.168.1.1',
    device_info='Chrome on macOS'
))

# Create an audit log
client.create_audit_log(CreateAuditLogRequest(
    action='user.signup',
    timestamp='2024-01-15T10:30:00Z',
    user_id='user_123',
    metadata={'plan': 'pro', 'source': 'web'}
))
```
