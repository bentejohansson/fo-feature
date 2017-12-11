#!/bin/bash -e

envsubst < /nginx.conf.template > /etc/nginx/conf.d/default.conf
envsubst < /www/_environments/404.template.json > /www/_environments/404.json
exec "$@"
