FROM debian:bullseye AS base
ENV LANG=C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive

# Install ca-certificates and change to jp repo
RUN <<EORUN
set -eux
apt-get update
apt-get install ca-certificates apt-utils -y
sed -i 's/^deb http:\/\/deb.debian.org\/debian /deb https:\/\/ftp.udx.icscoe.jp\/Linux\/debian /g' /etc/apt/sources.list
apt-get update
apt-get upgrade -y
apt-get clean
rm -rf /var/lib/apt/lists/*
EORUN


FROM base
SHELL [ "/bin/bash", "-c" ]
# Install gosu
RUN <<EORUN
set -eux
apt-get update
apt-get install -y gosu
rm -rf /var/lib/apt/lists/*
# verify that the binary works
gosu nobody true
EORUN
RUN <<EORUN
set -eux
cat <<EOF | tee /etc/apt/preferences.d/99phpfpm
Package: php*
Pin: release *
Pin-Priority: 900
EOF
apt-get update
apt-get install -y apt-transport-https lsb-release ca-certificates curl gnupg
curl -fsSL https://mirror.cat.net/sury/php/apt.gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/php.gpg
echo "deb https://mirror.cat.net/sury/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list
apt-get update
apt-get upgrade -y
apt-get install -y php8.4-fpm
apt-get clean
rm -rf /var/lib/apt/lists/*
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

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

STOPSIGNAL SIGQUIT
EXPOSE 9000

CMD [ "php-fpm8.4", "-F" ]
