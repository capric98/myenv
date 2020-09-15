#!/bin/bash
# Usage: curl -fsSL https://raw.githubusercontent.com/capric98/myenv/master/V2Ray/install.sh | bash -s ${User} ${Group}
USER=$1
GROUP=$2
VERSION="4.28.1"

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root!"
   exit 1
fi

id "$USER" >>/dev/null

if [[ "$?" -eq "1" ]]; then
    echo -e "User $USER does not exist, trying to add it..."
    groupadd -r $GROUP >> /dev/null
    useradd -g $GROUP -s /sbin/nologin -M $USER
fi

apt-get update >> /dev/null
apt-get install curl unzip ca-certificates

curl -o "v2ray-${VERSION}.zip" -L "https://github.com/v2fly/v2ray-core/releases/download/v${VERSION}/v2ray-linux-64.zip"

unzip v2ray-${VERSION}.zip -d /tmp/v2ray-${VERSION}

mkdir -p /usr/local/share/v2ray
mkdir -p /usr/local/etc/v2ray
mkdir -p /var/log/v2ray
touch /var/log/v2ray/access.log /var/log/v2ray/error.log

mv /tmp/v2ray-${VERSION}/geosite.dat /tmp/v2ray-${VERSION}/geoip.dat /usr/local/share/v2ray
mv /tmp/v2ray-${VERSION}/v2ray /tmp/v2ray-${VERSION}/v2ctl /usr/local/bin
touch /usr/local/etc/v2ray/config.json

chown ${USER}:${GROUP} /usr/local/share/v2ray /usr/local/etc/v2ray /var/log/v2ray

rm -rf /tmp/v2ray-${VERSION} v2ray-${VERSION}.zip

echo -e "[Unit]
Description=V2Ray Service
After=network.target nss-lookup.target

[Service]
User=${USER}
Group=${GROUP}
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
Environment=V2RAY_LOCATION_ASSET=/usr/local/share/v2ray/
ExecStart=/usr/local/bin/v2ray -config /usr/local/etc/v2ray/config.json
Restart=on-failure

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/v2ray.service

systemctl enable v2ray.service