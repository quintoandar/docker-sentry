#!/bin/bash

NEW_RELIC_CONFIG_FILE=newrelic.ini
newrelic-admin generate-config ${NEW_RELIC_LICENSE_KEY} newrelic.ini

echo "" >> /etc/sentry/sentry.conf.py
echo "SENTRY_FEATURES['auth:register'] = False" >> /etc/sentry/sentry.conf.py

sed -i \
    -e "s~AWS_ACCESS_KEY~$AWS_ACCESS_KEY~g" \
    -e "s~AWS_SECRET_KEY~$AWS_SECRET_KEY~g" \
    -e "s~AWS_S3_BUCKET_NAME~$AWS_S3_BUCKET_NAME~g" /etc/sentry/config.yml


#This to replicate owner directory on entrypoint file original
mkdir -p "$SENTRY_FILESTORE_DIR"
chown -R sentry "$SENTRY_FILESTORE_DIR"


function set_newrelic_conf {
  sed -i "/^app_name/c\app_name = $NEW_RELIC_APP_NAME" newrelic.ini
}

if [ -z "${@+x}" ]; then
  if [ ! -z "${WORKER+x}" ] && [ "$WORKER" = "true" ]; then
    set_newrelic_conf
    echo "Starting sentry worker..."
    exec tini gosu sentry newrelic-admin run-program sentry run worker

  elif [ ! -z "${CRON+x}" ] && [ "$CRON" = "true" ] ; then
    set_newrelic_conf
    echo "Starting sentry cron..."
    exec tini gosu sentry newrelic-admin run-program sentry run cron
  else
    set_newrelic_conf
    echo "Starting sentry webserver..."
    exec tini gosu sentry newrelic-admin run-program sentry run web
  fi
else
  echo "Running $@"
  exec /entrypoint.sh "$@"
fi
