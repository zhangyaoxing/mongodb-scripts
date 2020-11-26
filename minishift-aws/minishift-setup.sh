#!/bin/sh
echo 'Generating SSH key'
ssh-keygen
cat ~/.ssh/id_rsa.pub | sudo tee -a /root/.ssh/authorized_keys
sudo sed -i 's%#PermitRootLogin yes%PermitRootLogin yes%' /etc/ssh/sshd_config
sudo sed -i 's%PasswordAuthentication no%PasswordAuthentication yes%' /etc/ssh/sshd_config
sudo sed -i 's/disable_root: 1/disable_root false/' /etc/cloud/cloud.cfg
sudo service sshd reload

sudo yum install -y git
curl -OL https://github.com/minishift/minishift/releases/download/v1.34.2/minishift-1.34.2-linux-amd64.tgz
tar -zxvf minishift-1.34.2-linux-amd64.tgz
cd minishift-1.34.2-linux-amd64

host=`curl http://169.254.169.254/latest/meta-data/public-hostname`
ssh-copy-id root@$host
./minishift config set remote-ipaddress $host
./minishift config set remote-ssh-key ~/.ssh/id_rsa
./minishift config set remote-ssh-user root
./minishift config set vm-driver generic
./minishift config view
./minishift start
echo `./minishift oc-env` | sudo tee -a ~/.bash_profile
echo `./minishift oc-env` | sudo tee -a ~/.bashrc

cd ..
git clone https://github.com/mongodb/mongodb-enterprise-kubernetes.git

echo "Minishift ready. Switch to root to use oc."