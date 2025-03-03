#!/bin/bash

set -e

if [ ! -d /var/www/html ]; then
    mkdir -p /var/www/html
    chown www-data:www-data /var/www/html
    chmod 1777 /var/www/html
fi

if [ ! -e /var/nginx/ssl/server.key ]; then
openssl genrsa -out /etc/nginx/ssl/server.key 2048
cat <<EOF | openssl req -new -key /etc/nginx/ssl/server.key -out /etc/nginx/ssl/server.csr
JP
Tokyo
Shinjuku
42

$DOMAIN_NAME



EOF
openssl x509 -req -days 365 -in /etc/nginx/ssl/server.csr -signkey /etc/nginx/ssl/server.key -out /etc/nginx/ssl/server.crt
fi

exec "$@"
