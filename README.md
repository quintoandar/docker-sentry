# A Custom Docker Image Sentry to use on AWS BeanStalk.

## Features

This image recipes has goal to use on AWS BeanStalk but it's possible to use any container service. This image override entrypoint.sh from original Sentry Dockerfile do run web, cron or worker based variable environment on BeanStalk, Docker Compose or argument on Docker Engine.

The same is to NewRelic License and NewRelic App Name.

### Variables
WORKER
WEB
CRON
NEW_RELIC_APP_NAME
NEW_RELIC_LICENSE_KEY
