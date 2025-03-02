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
    mv /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php
    cp /var/www/html/wordpress/wp-config.php /var/www/html/wordpress/wp-config-sample.php.bak
    sed -i "s|^define( 'DB_NAME', 'database_name_here' );|define( 'DB_NAME', '$MYSQL_DATABASE' );|g" /var/www/html/wordpress/wp-config.php
    sed -i "s|^define( 'DB_USER', 'username_here' );|define( 'DB_USER', '$MYSQL_USER' );|g" /var/www/html/wordpress/wp-config.php
    sed -i "s|^define( 'DB_PASSWORD', 'password_here' );|define( 'DB_PASSWORD', '$(cat /run/secrets/mysql_password)' );|g" /var/www/html/wordpress/wp-config.php
    sed -i "s|^define( 'DB_HOST', 'localhost' );|define( 'DB_HOST', 'mariadb' );|g" /var/www/html/wordpress/wp-config.php
    sed -i "s|^define( 'AUTH_KEY',         'put your unique phrase here' );|define( 'AUTH_KEY',         '$(openssl rand -hex 20)' );|g" /var/www/html/wordpress/wp-config.php
    sed -i "s|^define( 'SECURE_AUTH_KEY',  'put your unique phrase here' );|define( 'SECURE_AUTH_KEY',  '$(openssl rand -hex 20)' );|g" /var/www/html/wordpress/wp-config.php
    sed -i "s|^define( 'LOGGED_IN_KEY',    'put your unique phrase here' );|define( 'LOGGED_IN_KEY',    '$(openssl rand -hex 20)' );|g" /var/www/html/wordpress/wp-config.php
    sed -i "s|^define( 'NONCE_KEY',        'put your unique phrase here' );|define( 'NONCE_KEY',        '$(openssl rand -hex 20)' );|g" /var/www/html/wordpress/wp-config.php
    sed -i "s|^define( 'AUTH_SALT',        'put your unique phrase here' );|define( 'AUTH_SALT',        '$(openssl rand -hex 20)' );|g" /var/www/html/wordpress/wp-config.php
    sed -i "s|^define( 'SECURE_AUTH_SALT', 'put your unique phrase here' );|define( 'SECURE_AUTH_SALT', '$(openssl rand -hex 20)' );|g" /var/www/html/wordpress/wp-config.php
    sed -i "s|^define( 'LOGGED_IN_SALT',   'put your unique phrase here' );|define( 'LOGGED_IN_SALT',   '$(openssl rand -hex 20)' );|g" /var/www/html/wordpress/wp-config.php
    sed -i "s|^define( 'NONCE_SALT',       'put your unique phrase here' );|define( 'NONCE_SALT',       '$(openssl rand -hex 20)' );|g" /var/www/html/wordpress/wp-config.php
    chmod 1777 /var/www/html/wordpress
fi

exec "$@"
