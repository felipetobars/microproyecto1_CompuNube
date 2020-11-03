#!/usr/bin/env bash
apt update && apt upgrade 

echo '----CREANDO CONTENEDOR WEB1----'
lxc launch ubuntu:18.04 web1 --target vmServidor1
sleep 5
echo '----UPDATE AND UPGRADE EN EL CONTENEDOR----'
lxc exec web1 -- sudo apt update
lxc exec web1 -- sudo apt upgrade -y
sleep 10
echo '----INSTALANDO APACHE----'
lxc exec web1 -- apt-get install apache2 -y 
echo '----HABILITANDO APACHE----'
lxc exec web1 -- systemctl enable apache2
sleep 10

echo "Configurando index.html"

touch /home/vagrant/index.html
cat <<TEST> /home/vagrant/index.html
<!DOCTYPE html>
<html>
<head>
<title>Pagina de prueba</title>
</head>
<body background="https://www.practia.global/Industrias/PublishingImages/BannerTecnologia.jpg">
<h1><center><p style="color:rgb(255,255,255);">Pagina web de prueba</p></center></h1>
<font size=”3″ face=”Comic Sans MS, Arial, MS Sans Serif”>
<center><p style="color:rgb(255,255,255);">Usted ahora mismo esta usando el servidor web1</p></center></font>
<h2><center><p style="color:rgb(255,255,255);">--usando web1--</p><center></h2>
</body>
</html>
TEST

lxc file push /home/vagrant/index.html web1/var/www/html/index.html
echo '----RESTART A APACHE----'
lxc exec web1 -- systemctl restart apache2

sleep 5

#SERVIDOR DE BACKUP
echo '----CREANDO CONTENEDOR WEB4----'
lxc launch ubuntu:18.04 web4 --target vmServidor1
sleep 5
echo '----UPDATE AND UPGRADE EN EL CONTENEDOR----'
lxc exec web4 -- sudo apt update
lxc exec web4 -- sudo apt upgrade -y
sleep 10
echo '----INSTALANDO APACHE----'
lxc exec web4 -- apt-get install apache2 -y
echo '----HABILITANDO APACHE----'
lxc exec web4 -- systemctl enable apache2
sleep 5

echo "Configurando index.html"

touch /home/vagrant/index.html
cat <<TEST> /home/vagrant/index.html
<!DOCTYPE html>
<html>
<head>
<title>Pagina de prueba</title>
</head>
<body background="https://www.practia.global/Industrias/PublishingImages/BannerTecnologia.jpg">
<h1><center><p style="color:rgb(255,255,255);">Pagina web de prueba</p></center></h1>
<font size=”3″ face=”Comic Sans MS, Arial, MS Sans Serif”>
<center><p style="color:rgb(255,255,255);">Usted ahora mismo esta usando el servidor web2</p></center></font>
<h2><center><p style="color:rgb(255,255,255);">--usando backup web4--</p><center></h2>
</body>
</html>
TEST

lxc file push /home/vagrant/index.html web4/var/www/html/index.html
echo '----RESTART A APACHE----'
lxc exec web4 -- systemctl restart apache2



