---
title: PHP SDK
type: docs
prev: docs/sdks/python
next: docs/changelog
---

## Install

```bash
composer require logtracehq/logtrace-php
```

## Usage

```php
use Logtrace\Logtrace;
require 'vendor/autoload.php';

$client = new Logtrace(getenv('LOGTRACE_API_KEY'));

// Track an event
$client->createEvent([
    'action_name'       => 'user_signup',
    'user_id'           => 'user_123',
    'http_method'       => 'POST',
    'http_status'       => '200',
    'client_ip'         => '192.168.1.1',
    'client_user_agent' => 'Mozilla/5.0',
]);

// Create a session
$client->createSession([
    'login_at'    => date('c'),
    'status'      => 'ACTIVE',
    'user_id'     => 'user_123',
    'ip_address'  => '192.168.1.1',
    'device_info' => 'Chrome on macOS',
]);

// Create an audit log
$client->createAuditLog([
    'action'    => 'user.signup',
    'timestamp' => date('c'),
    'user_id'   => 'user_123',
    'metadata'  => ['plan' => 'pro', 'source' => 'web'],
]);
```
