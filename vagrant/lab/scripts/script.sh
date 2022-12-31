#!/bin/bash -e

config_init()
{
echo '=============================='
echo 'COnfigurações Iniciais'
echo '=============================='
HOSTS=$(head -n7 /etc/hosts)
echo -e "$HOSTS" > /etc/hosts
sudo apt update
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config 
sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config   
systemctl restart sshd.service
sudo echo "vagrant:vagrant" | sudo chpasswd
sudo echo "root:123456" | sudo chpasswd
sudo usermod -aG sudo vagrant
sudo cp /vagrant/.ssh/* /root/.ssh/
sudo cp /vagrant/.ssh/* /home/vagrant/.ssh/
}


install_docker()
{
curl https://releases.rancher.com/install-docker/20.10.sh | sh
sudo usermod -aG docker vagrant
sudo chmod 666 /var/run/docker.sock
}

config_init
install_docker