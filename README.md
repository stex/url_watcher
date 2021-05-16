# url_watcher

A very simple script / docker image to watch for changes on a web page and
call a webhook on `diff` changes.

Currently doesn't support webhook arguments, simply performs a `POST` request.

## Docker Usage

Simply set the page and webhook URLs as environment variables when running the docker image:

```bash
docker run -t --rm -e PAGE_URL=https://google.com -e WEBHOOK_URL=https://my.webhook.com sterexx/url_watcher
```

or as compose file:

```yaml
version: "3"

services:
  app:
    image: sterexx/url_watcher
    environment:
      PAGE_URL: https://google.com
      WEBHOOK_URL: https://my.webhook.com
    restart: unless-stopped
```

## Script Usage

Specify the page to watch and the webhook URL via environment variables:

```bash
PAGE_URL=https://google.com WEBHOOK_URL=https://my.webhook.com ./watcher.rb
```
