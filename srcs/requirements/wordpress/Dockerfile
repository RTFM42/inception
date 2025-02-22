FROM debian:bullseye AS base
ENV LANG=C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive

# Install ca-certificates and change to jp repo
RUN <<EORUN
set -eux
> /dev/null apt-get update
> /dev/null apt-get install ca-certificates apt-utils -y
> /dev/null sed -i 's/^deb http:\/\/deb.debian.org\/debian /deb https:\/\/ftp.udx.icscoe.jp\/Linux\/debian /g' /etc/apt/sources.list
> /dev/null apt-get update
> /dev/null apt-get upgrade -y
> /dev/null apt-get clean
> /dev/null rm -rf /var/lib/apt/lists/*
EORUN


FROM base
SHELL [ "/bin/bash", "-c" ]
RUN <<EORUN
set -eux
> /dev/null cat <<EOF | tee /etc/apt/preferences.d/99phpfpm
Package: php*
Pin: release *
Pin-Priority: 900
EOF
> /dev/null apt-get update
> /dev/null apt-get install -y apt-transport-https lsb-release ca-certificates curl gnupg
curl -fsSL https://packages.sury.org/php/apt.gpg | \
> /dev/null gpg --dearmor -o /etc/apt/trusted.gpg.d/php.gpg
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | \
> /dev/null tee /etc/apt/sources.list.d/php.list
> /dev/null apt-get update
> /dev/null apt-get upgrade -y
> /dev/null apt-get install -y php8.4-fpm
> /dev/null apt-get clean
> /dev/null rm -rf /var/lib/apt/lists/*
EORUN

ENV PHP_INI_DIR=/usr/local/etc/php
RUN <<EORUN
set -eux
mkdir -p "$PHP_INI_DIR/conf.d"
mkdir /run/php
[ ! -d /var/www/html ];
mkdir -p /var/www/html
chown www-data:www-data /var/www/html
chmod 1777 /var/www/html
EORUN


STOPSIGNAL SIGQUIT
EXPOSE 9000

CMD [ "php-fpm8.4", "-F" ]
