# frueh

A tiny HTTP server for collecting email addresses. Perfect for early access landing pages.

Posts the submitted data to a log file and sends you an email notification.

## Build

Requires [Nim](https://nim-lang.org/) and the `mummy` package.

```bash
nimble install mummy
nim c -d:release frueh.nim
```

## Usage

```bash
FRUEH_MAIL_FROM=notify@example.com \
FRUEH_MAIL_TO=you@example.com \
./frueh
```

Then POST to it from your landing page:

```javascript
fetch('http://localhost:3445/', {
  method: 'POST',
  body: email
})
```

Submissions are appended to `/var/lib/frueh/frueh.log` (one per line).

## Configuration

All settings via environment variables:

| Variable | Default | Description |
|----------|---------|-------------|
| `FRUEH_PORT` | 3445 | Server port |
| `FRUEH_HOST` | localhost | Server host |
| `FRUEH_FILE` | /var/lib/frueh/frueh.log | Log file path |
| `FRUEH_MAIL_HOST` | localhost | SMTP server |
| `FRUEH_MAIL_PORT` | 25 | SMTP port |
| `FRUEH_MAIL_SSL` | false | Use SSL |
| `FRUEH_MAIL_USERNAME` | - | SMTP auth (optional) |
| `FRUEH_MAIL_PASSWORD` | - | SMTP auth (optional) |
| `FRUEH_MAIL_FROM` | - | Sender address (required) |
| `FRUEH_MAIL_TO` | - | Recipients, colon-separated (required) |

## License

MIT
