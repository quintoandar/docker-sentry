FROM sentry:8.20

ADD custom-entrypoint.sh /bin/

RUN pip install newrelic

ENTRYPOINT ["custom-entrypoint.sh"]
