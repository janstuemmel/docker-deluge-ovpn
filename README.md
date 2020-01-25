# docker deluge ovpenvpn

This image sets up a deluge daemon and routes all trafic over an openvpn tunnel. The firewall is configured as a kill switch.

## Usage

```yml
version: '3'

services: 
  app:
    build: .
    cap_add:
      - NET_ADMIN
    devices:
      - /dev/net/tun 
    ports:
      # the deluge connection port
      - 58846:58846
    volumes:
      # provide a open vpn configuration
      # this includes 
      #   - a vpn configuration file named config.ovpn
      #   - a auth file configured in config.ovpn  
      - ./ovpn:/ovpn
      # mount download folder
      - ./downloads:/app/Downloads
```


## Resources

* [blogpost about ufw killswitch](https://www.codeproject.com/Articles/1266552/Create-a-VPN-killswitch-with-UFW)