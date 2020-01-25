FROM alpine:edge

ENV PS1="\u@\w\$ "

RUN addgroup app && adduser -h /app -S -u 1000 -s /bin/bash app -G app

RUN echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \ 
  && apk --no-cache add bash vim openvpn curl ip6tables ufw@testing deluge@testing \
  && sed -i s/IPV6=yes/IPV6=no/g /etc/default/ufw

RUN mkdir /ovpn /deluge /app/Downloads \
  && chown app.app -R /deluge /app

ADD entrypoint.sh /usr/local/bin

RUN echo "admin:admin:10" > "/deluge/auth"

WORKDIR /ovpn

VOLUME /deluge /app/Downloads

EXPOSE 58846

ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]