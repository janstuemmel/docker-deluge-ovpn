[![](https://images.microbadger.com/badges/version/janstuemmel/deluge-ovpn.svg)](https://hub.docker.com/r/janstuemmel/deluge-ovpn)


# docker deluge ovpenvpn

This image sets up a deluge daemon and routes all trafic over an openvpn tunnel. The firewall is configured as a kill switch.

The image is designed to provide the simplest approach to tunnel internet trafic inside a container over a vpn. 

The firewall is written with ufw, check the [entrypoint.sh](./entrypoint.sh) sh file. 

## Usage

Create a directory `./ovpn` for example in the same directory as your `docker-compose.yml` file. Copy your openvpn configuration files in there. Openvpn configuration files must have the extension `ovpn`. 

When your vpn provider needs authentication via username/password, create file in `/ovpn` and insert your username in the first line, your password in the second line:

```
myusername
mys3cretpassword
```

Edit your .ovpn file and add a line with `auth-user-pass myauth.txt`. Alternativly you can specify the file in the environment variables. See below:

```yml
version: '3'

services: 
  app:
    image: janstuemmel/deluge-ovpn
    cap_add:
      - NET_ADMIN
    devices:
      - /dev/net/tun 
    ports:
      # the deluge connection port
      - 58846:58846
    environment:
      # select port to open outgoing 
      # connections for vpn, default: 1194 
      - OVPN_PORT=1194
      # select a specific .ovpn file to execute,
      # default: random .ovpn file in /ovpn
      - OVPN_CONFIG=default.ovpn
      # select a specific auth file to use when 
      # connecting, will override specified auth
      # file in .ovpn file, default: none
      - OVPN_AUTH_FILE=auth.txt
    volumes:
      # provide a open vpn configuration 
      # directory with all for .ovpn configs
      # and maybe auth files
      - ./ovpn:/ovpn
      # mount download folder
      - ./downloads:/app/Downloads
```

Start service with `docker-compose up -d`. Debug vpn connection then with `docker-compose logs -f`. You can check your torrent ip with [ipleak.net](https://ipleak.net/).

After that you can connect to the daemon with the geluge gtk ui or the webinterface. The default credentials are `admin/admin`.

## Resources

* [blogpost about ufw killswitch](https://www.codeproject.com/Articles/1266552/Create-a-VPN-killswitch-with-UFW)