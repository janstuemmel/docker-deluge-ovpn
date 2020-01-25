#!/bin/bash

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
ufw allow out 1194

# enable ufw
ufw enable

# start deluge as user app and fork
su - app -c "deluged -d -c /deluge -u 0.0.0.0 -p 58846" &

# start opvn
openvpn --config config.ovpn --dev tun0 $@