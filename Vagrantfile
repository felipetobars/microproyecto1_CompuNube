Vagrant.configure("2") do |config|

 #Balanceador
 config.vm.define :vmBalanceador do |vmBalanceador|
 vmBalanceador.vm.box = "bento/ubuntu-20.04"
 vmBalanceador.vm.network :private_network, ip: "192.168.100.5"
 vmBalanceador.vm.provision "shell", path: "clusterBalanceador.sh"
 vmBalanceador.vm.hostname = "vmBalanceador"
 vmBalanceador.vm.provider "virtualbox" do |v|
 	v.name = "vmBalanceador"
 	v.memory =1024
 	v.cpus=1
 end
 end

#Servidor 1
 config.vm.define :vmServidor1 do |vmServidor1|
 vmServidor1.vm.box = "bento/ubuntu-20.04"
 vmServidor1.vm.network :private_network, ip: "192.168.100.6"
 vmServidor1.vm.provision "shell", path: "clusterServidor1.sh"
 vmServidor1.vm.hostname = "vmServidor1"
 vmServidor1.vm.provider "virtualbox" do |v|
 	v.name = "vmServidor1"
 	v.memory =1024
 	v.cpus=1
 end
 end

#Servidor 2
 config.vm.define :vmServidor2 do |vmServidor2|
 vmServidor2.vm.box = "bento/ubuntu-20.04"
 vmServidor2.vm.network :private_network, ip: "192.168.100.7"
 vmServidor2.vm.provision "shell", path: "clusterServidor2.sh"
 vmServidor2.vm.provision "shell", path: "vmServidor1_cfg.sh"
 vmServidor2.vm.provision "shell", path: "vmServidor2_cfg.sh"
 vmServidor2.vm.provision "shell", path: "vmBalanceador_cfg.sh"
 vmServidor2.vm.hostname = "vmServidor2"
 vmServidor2.vm.provider "virtualbox" do |v|
 	v.name = "vmServidor2"
 	v.memory =1024
 	v.cpus=1
 end
 end
end
