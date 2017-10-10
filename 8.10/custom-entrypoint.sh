#!/bin/bash

echo "" >> /etc/sentry/sentry.conf.py
echo "SENTRY_FEATURES['auth:register'] = False" >> /etc/sentry/sentry.conf.py

if [ -z "${@+x}" ]; then
  if [ ! -z "${WORKER+x}" ] && [ "$WORKER" = "true" ]; then
    echo "Starting sentry worker..."
    exec /entrypoint.sh run worker
  elif [ ! -z "${CRON+x}" ] && [ "$CRON" = "true" ] ; then
    echo "Starting sentry cron..."
    exec /entrypoint.sh run cron
  else
    echo "Starting sentry webserver..."
    exec /entrypoint.sh run web
  fi
else
  echo "Running $@"
  exec /entrypoint.sh "$@"
fi
