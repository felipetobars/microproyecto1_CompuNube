#!/usr/bin/env bash
apt update && apt upgrade

echo '----CREANDO CONTENEDOR HAPROXY----'
lxc launch ubuntu:18.04 haproxy --target vmBalanceador
sleep 5
echo '----UPDATE AND UPGRADE EN EL CONTENEDOR----'
lxc exec haproxy -- sudo apt update
lxc exec haproxy -- sudo apt upgrade -y
sleep 10
echo '----INSTALANDO HAPROXY----'
lxc exec haproxy -- apt install haproxy -y
echo '----HABILITANDO HAPROXY----'
lxc exec haproxy -- systemctl enable haproxy
sleep 5

echo "----Configurando el haproxy.cfg con cat----"
touch /home/vagrant/haproxy.cfg
cat <<TEST> /home/vagrant/haproxy.cfg
global
	log /dev/log	local0
	log /dev/log	local1 notice
	chroot /var/lib/haproxy
	stats socket /run/haproxy/admin.sock mode 660 level admin expose-fd listeners
	stats timeout 30s
	user haproxy
	group haproxy
	daemon

	# Default SSL material locations
	ca-base /etc/ssl/certs
	crt-base /etc/ssl/private

	# Default ciphers to use on SSL-enabled listening sockets.
	# For more information, see ciphers(1SSL). This list is from:
	#  https://hynek.me/articles/hardening-your-web-servers-ssl-ciphers/
	# An alternative list with additional directives can be obtained from
	#  https://mozilla.github.io/server-side-tls/ssl-config-generator/?server=haproxy
	ssl-default-bind-ciphers ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:RSA+AESGCM:RSA+AES:!aNULL:!MD5:!DSS
	ssl-default-bind-options no-sslv3

defaults
	log	global
	mode	http
	option	httplog
	option	dontlognull
        timeout connect 5000
        timeout client  50000
        timeout server  50000
	errorfile 400 /etc/haproxy/errors/400.http
	errorfile 403 /etc/haproxy/errors/403.http
	errorfile 408 /etc/haproxy/errors/408.http
	errorfile 500 /etc/haproxy/errors/500.http
	errorfile 502 /etc/haproxy/errors/502.http
	errorfile 503 /etc/haproxy/errors/503.http
	errorfile 504 /etc/haproxy/errors/504.http


backend web-backend
   balance roundrobin
   stats enable
   stats auth admin:admin
   stats uri /haproxy?stats
   stats refresh 10s

   option allbackups
   server web1 web1.lxd:80 check
   server web2 web2.lxd:80 check
   server web3 web3.lxd:80 check backup
   server web4 web4.lxd:80 check backup

frontend http
  bind *:80
  default_backend web-backend

TEST

lxc file push /home/vagrant/haproxy.cfg haproxy/etc/haproxy/haproxy.cfg
echo '----RESTART A HAPROXY----'
lxc exec haproxy -- systemctl restart haproxy

sleep 5

lxc config device add haproxy httproxy proxy listen=tcp:0.0.0.0:1080 connect=tcp:127.0.0.1:80

sleep 5

touch /home/vagrant/503.html
cat <<TEST> /home/vagrant/503.html
HTTP/1.0 503 Service Unavailable
Cache-Control: no-cache
Connection: close
Content-Type: text/html

<html>
<head>
<title>Error 503</title>
</head>
<body background="https://www.practia.global/Industrias/PublishingImages/BannerTecnologia.jpg">
<h1><center><p style="color:rgb(255,255,255);">Actualmente no hay servidores disponibles</p></center></h1>
<font size=”3″ face=”Comic Sans MS, Arial, MS Sans Serif”>
<center><p style="color:rgb(255,255,255);">No hay servidores disponibles para atender el requerimiento</p></center></font>
<h2><center><p style="color:rgb(255,255,255);">--Error 503--</p><center></h2>
</body>
</html>
TEST

lxc file push /home/vagrant/503.html haproxy/etc/haproxy/errors/503.http

lxc exec haproxy -- systemctl restart haproxy