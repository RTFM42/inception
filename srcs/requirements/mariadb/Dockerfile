FROM debian:bullseye AS base
ENV LANG=C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive

# Install ca-certificates and change to jp repo
RUN <<EORUN
set -eux
apt-get update > /dev/null
apt-get install -y ca-certificates apt-utils > /dev/null
sed -i 's/^deb http:\/\/deb.debian.org\/debian /deb https:\/\/ftp.udx.icscoe.jp\/Linux\/debian /g' /etc/apt/sources.list > /dev/null
apt-get update > /dev/null
apt-get upgrade -y > /dev/null
apt-get clean > /dev/null
rm -rf /var/lib/apt/lists/* > /dev/null
EORUN


FROM base

# Install gosu
RUN <<EORUN
set -eux > /dev/null
apt-get update > /dev/null
apt-get install -y gosu > /dev/null
rm -rf /var/lib/apt/lists/* > /dev/null
# verify that the binary works
gosu nobody true > /dev/null
EORUN

# Install maraidb
RUN <<EORUN
set -eux > /dev/null
apt-get update > /dev/null
apt-get install -y curl > /dev/null
curl -LsS https://r.mariadb.com/downloads/mariadb_repo_setup | bash > /dev/null
apt-get update > /dev/null
apt-get install -y mariadb-server > /dev/null
apt-get remove -y curl > /dev/null
apt-get clean > /dev/null
rm -rf /var/lib/apt/lists/* > /dev/null
EORUN
RUN rm -rf /var/lib/mysql
RUN mkdir -p /run/mysqld /var/lib/mysql
RUN chown -R mysql:mysql /run/mysqld

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["mariadbd", "--gdb"]
