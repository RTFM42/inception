#!/bin/bash

set -e

if [ ! -d /var/www/html ]; then
    mkdir -p /var/www/html
    chown -R www-data:www-data /var/www/html
    chmod 1777 /var/www/html
fi
if [ ! -d /var/www/html/wordpress ]; then
    curl -sLO https://ja.wordpress.org/latest-ja.zip
    unzip -d /var/www/html latest-ja.zip
    chown -R www-data:www-data /var/www/html/wordpress
    chmod 1777 /var/www/html/wordpress
fi

exec "$@"
