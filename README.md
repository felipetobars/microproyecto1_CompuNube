# microproyecto1_CompuNube
Proyecto realizado para la materia de Computación en la Nube, donde se crean 3 máquinas virtuales con VirtualBox administradas con Vagrant, donde se monta un balanceador de carga HAProxy y servidores web apache sobre contenedores LXC en una máquinas virtuales distintas. Para lo anterior se utiliza clustering LXD y además se aprovisiona todo el proceso por medio de archivos Shell, lo que permite dejar todo el proyecto funcional con sólo ejecutar 'vagrant up' para su creación.