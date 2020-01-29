#!/bin/bash

set -e

sleep 1s # wait for fab db

if ! [ "$(flask fab list-users | grep Admin)" ]; then
    /bin/sh /superset-init.sh "$ADMIN_USER" "$ADMIN_FNAME" "$ADMIN_LNAME" \
           "$ADMIN_EMAIL" "$ADMIN_PW"
fi

gunicorn --bind  0.0.0.0:8088 \
        -k gevent \
        --workers 3 \
        --threads 4 \
        --timeout 60 \
        --limit-request-line 0 \
        --limit-request-field_size 0 \
        superset:app
