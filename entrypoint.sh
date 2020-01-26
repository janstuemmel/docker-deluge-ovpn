#!/bin/bash

OVPN_PORT=${OVPN_PORT:-1194}
OVPN_CONFIG=${OVPN_CONFIG:-`ls *.ovpn | shuf -n 1`}

echo "...using openvpn config: $OVPN_CONFIG"

if [ -n "$OVPN_AUTH_FILE" ]; then
  OVPN_AUTH="--auth-user-pass $OVPN_AUTH_FILE"
fi

subnet=`ip addr | grep "global eth0" | awk '{print $2}'`

# allow local network
ufw allow in to $subnet
ufw allow out to $subnet

# disable internet
ufw default deny outgoing
ufw default deny incoming

# enable internet through tun0
ufw allow in on tun0 from any to any
ufw allow out on tun0 from any to any

# allow openvpn connections
ufw allow out $OVPN_PORT

# enable ufw
ufw enable

# start deluge as user app and fork
su - app -c "deluged -d -c /deluge -u 0.0.0.0 -p 58846" &

# start opvn
openvpn \
  --config $OVPN_CONFIG \
  --dev tun0 \
  $OVPN_AUTH \
  $@