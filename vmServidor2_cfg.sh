#!/usr/bin/env bash
apt update && apt upgrade

echo '----CREANDO CONTENEDOR WEB2----'
lxc launch ubuntu:18.04 web2 --target vmServidor2
sleep 5
echo '----UPDATE AND UPGRADE EN EL CONTENEDOR----'
lxc exec web2 -- sudo apt update 
lxc exec web2 -- sudo apt upgrade -y
sleep 10
echo '----INSTALANDO APACHE----'
lxc exec web2 -- apt-get install apache2 -y 
echo '----HABILITANDO APACHE----'
lxc exec web2 -- systemctl enable apache2
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
<center><p style="color:rgb(255,255,255);">Usted ahora mismo esta usando el servidor web2</p></center></font>
<h2><center><p style="color:rgb(255,255,255);">--usando web2--</p><center></h2>
</body>
</html>
TEST

lxc file push /home/vagrant/index.html web2/var/www/html/index.html
echo '----RESTART A APACHE----'
lxc exec web2 -- systemctl restart apache2

sleep 5

#SERVIDOR DE BACKUP
echo '----CREANDO CONTENEDOR WEB3----'
lxc launch ubuntu:18.04 web3 --target vmServidor2
sleep 5
echo '----UPDATE AND UPGRADE EN EL CONTENEDOR----'
lxc exec web3 -- sudo apt update
lxc exec web3 -- sudo apt upgrade -y
sleep 10
echo '----INSTALANDO APACHE----'
lxc exec web3 -- apt-get install apache2 -y 
echo '----HABILITANDO APACHE----'
lxc exec web3 -- systemctl enable apache2
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
<center><p style="color:rgb(255,255,255);">Usted ahora mismo esta usando el servidor web1</p></center></font>
<h2><center><p style="color:rgb(255,255,255);">--usando backup web3--</p><center></h2>
</body>
</html>
TEST

lxc file push /home/vagrant/index.html web3/var/www/html/index.html
echo '----RESTART A APACHE----'
lxc exec web3 -- systemctl restart apache2



