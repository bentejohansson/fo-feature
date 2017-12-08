#!/bin/bash -e

export > /www/env.txt
envsubst < /nginx.conf.template > /etc/nginx/conf.d/default.conf
exec "$@"
