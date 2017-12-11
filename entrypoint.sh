#!/bin/bash -e

envsubst < /nginx.conf.template > /etc/nginx/conf.d/default.conf
envsubst < /404.json.template > /www/404.json
exec "$@"
