#!/bin/bash -e

config_init()
{
echo '=============================='
echo 'Configurações Iniciais'
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
sudo cp /vagrant/ssh/* /root/.ssh/
sudo cp /vagrant/ssh/* /home/vagrant/.ssh/
}


install_rancher()
{
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

curl -s https://api.github.com/repos/rancher/rke/releases/latest | grep download_url | grep amd64 | cut -d '"' -f 4 | wget -qi -
chmod +x rke_linux-amd64
sudo mv rke_linux-amd64 /usr/local/bin/rke

sudo cp /vagrant/cluster/cluster.yml /home/vagrant/cluster.yml
sudo chmod 777 /home/vagrant/cluster.yml
sudo rke up
sudo mkdir /root/.kube
sudo cp kube_config_cluster.yml ~/.kube/config
}

config_init
install_rancher