#!/bin/bash

set -e

if [ ! -d /var/www/html ]; then
    mkdir -p /var/www/html
    chown www-data:www-data /var/www/html
    chmod 1777 /var/www/html
fi

exec gosu www-data "$@"
