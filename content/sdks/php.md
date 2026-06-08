---
title: PHP SDK
type: docs
prev: sdks/python
next: changelog
---

## Install

```bash
composer require logtracehq/logtrace-php
```

## Usage

```php
use Logtrace\Client;
use Logtrace\CreateEventRequest;

$client = new Client(getenv('LOGTRACE_API_KEY'));

$client->createEvent(new CreateEventRequest(
    name:      'user.signup',
    userId :       'user_123',
    type:         'authentication',
    metadata:     [
        'plan' => 'pro',
        'referrer' => 'google',
    ],
));

$client->createSession(new CreateSessionRequest(...));
$client->createAuditLog(new CreateAuditLogRequest(...));
```
