FROM debian:bullseye AS base
ENV LANG=C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive

# Install ca-certificates and change to jp repo
RUN <<EORUN
set -eux
apt-get update > /dev/null
apt-get install ca-certificates apt-utils -y > /dev/null
sed -i 's/^deb http:\/\/deb.debian.org\/debian /deb https:\/\/ftp.udx.icscoe.jp\/Linux\/debian /g' /etc/apt/sources.list > /dev/null
apt-get update > /dev/null
apt-get upgrade -y > /dev/null
apt-get clean > /dev/null
rm -rf /var/lib/apt/lists/* > /dev/null
EORUN


FROM base
RUN <<EORUN
set -eux
apt-get update > /dev/null
apt-get install -y curl gnupg2 ca-certificates lsb-release debian-archive-keyring > /dev/null
curl -s https://nginx.org/keys/nginx_signing.key | gpg --dearmor | tee /usr/share/keyrings/nginx-archive-keyring.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] http://nginx.org/packages/debian `lsb_release -cs` nginx" | tee /etc/apt/sources.list.d/nginx.list > /dev/null
cat <<EOF | tee /etc/apt/preferences.d/99nginx > /dev/null
Package: *
Pin: origin nginx.org
Pin: release o=nginx
Pin-Priority: 900
EOF
apt-get update > /dev/null
apt-get install -y nginx > /dev/null
apt-get clean > /dev/null
rm -rf /var/lib/apt/lists/* > /dev/null
EORUN

STOPSIGNAL SIGQUIT
EXPOSE 80

CMD [ "nginx", "-g", "daemon off;" ]
