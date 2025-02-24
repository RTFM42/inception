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
apt-get update
apt-get install -y curl gnupg2 ca-certificates lsb-release debian-archive-keyring
curl -s https://nginx.org/keys/nginx_signing.key | gpg --dearmor -o /usr/share/keyrings/nginx-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] http://nginx.org/packages/debian `lsb_release -cs` nginx" | tee /etc/apt/sources.list.d/nginx.list
cat <<EOF | tee /etc/apt/preferences.d/99nginx
Package: *
Pin: origin nginx.org
Pin: release o=nginx
Pin-Priority: 900
EOF
apt-get update
apt-get install -y nginx
apt-get clean
rm -rf /var/lib/apt/lists/*
EORUN

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

STOPSIGNAL SIGQUIT
EXPOSE 80
EXPOSE 443

CMD [ "nginx", "-g", "daemon off;" ]
