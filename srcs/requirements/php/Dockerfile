FROM debian:bullseye AS base
ENV LANG=C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive

# Install ca-certificates and change to jp repo
RUN <<EORUN
set -eux
apt-get update
apt-get install ca-certificates apt-utils -y
sed -i 's|^deb http://deb.debian.org/debian |deb https://ftp.udx.icscoe.jp/Linux/debian |g' /etc/apt/sources.list
apt-get update
apt-get upgrade -y
apt-get clean
rm -rf /var/lib/apt/lists/*
EORUN


FROM base
SHELL [ "/bin/bash", "-c" ]
RUN <<EORUN
set -eux
cat <<EOF | tee /etc/apt/preferences.d/99phpfpm
Package: php*
Pin: release *
Pin-Priority: 900
EOF
apt-get update
apt-get install -y apt-transport-https lsb-release ca-certificates curl gnupg
curl -fsSL https://packages.sury.org/php/apt.gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/php.gpg
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list
apt-get update
apt-get upgrade -y
apt-get install -y unzip curl php-fpm php-mysql php-gd php-cli php-mbstring mariadb-client
apt-get clean
rm -rf /var/lib/apt/lists/*
EORUN

RUN mkdir /run/php
RUN cp /etc/php/8.3/fpm/pool.d/www.conf /etc/php/8.3/fpm/pool.d/www.conf.bak
RUN sed -i 's|^listen = /run/php/.*|listen = 9000|' /etc/php/8.3/fpm/pool.d/www.conf
RUN sed -i '/^listen.owner = www-data/d' /etc/php/8.3/fpm/pool.d/www.conf
RUN sed -i '/^listen.group = www-data/d' /etc/php/8.3/fpm/pool.d/www.conf

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp

ARG TIMESTAMP=
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

STOPSIGNAL SIGQUIT
EXPOSE 9000

CMD [ "php-fpm8.3", "-F" ]
