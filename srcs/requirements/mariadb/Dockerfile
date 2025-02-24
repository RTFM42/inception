FROM debian:bullseye AS base
ENV LANG=C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive

# Install ca-certificates and change to jp repo
RUN <<EORUN
set -eux
apt-get update
apt-get install -y ca-certificates apt-utils
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

# Install maraidb
RUN <<EORUN
set -eux
apt-get update
apt-get install -y curl
curl -LsS https://r.mariadb.com/downloads/mariadb_repo_setup | bash
apt-get update
apt-get install -y mariadb-server
apt-get remove -y curl
apt-get clean
rm -rf /var/lib/apt/lists/*
EORUN
RUN rm -rf /var/lib/mysql
RUN mkdir -p /run/mysqld /var/lib/mysql
RUN chown -R mysql:mysql /run/mysqld

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

STOPSIGNAL SIGQUIT
EXPOSE 3306

CMD ["mariadbd", "--gdb"]
