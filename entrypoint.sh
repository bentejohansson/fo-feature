#!/bin/bash -e

envsubst < /templates/nginx.conf > /etc/nginx/conf.d/default.conf
envsubst < /templates/404.json > /www/_environments/404.json
exec "$@"
