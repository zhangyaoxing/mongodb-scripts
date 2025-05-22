#!/bin/bash
# add mongodb source
sudo apt-get install -y gnupg curl
curl -fsSL https://pgp.mongodb.com/server-8.0.asc | \
   sudo gpg -o /usr/share/keyrings/mongodb-server-8.0.gpg \
   --dearmor
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-8.0.gpg ] https://repo.mongodb.com/apt/ubuntu noble/mongodb-enterprise/8.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-enterprise-8.0.list
sudo apt-get update
sudo apt-get install -y mongodb-enterprise

# Download & install Ops Manager
curl -O https://downloads.mongodb.com/on-prem-mms/deb/mongodb-mms-8.0.7.500.20250505T1425Z.amd64.deb
sudo dpkg -i mongodb-mms-8.0.7.500.20250505T1425Z.amd64.deb

echo -e "
mms.fromEmailAddr=admin@yaoxing.online
mms.replyToEmailAddr=admin@yaoxing.online
mms.adminEmailAddr=admin@yaoxing.online
mms.emailDaoClass=com.xgen.svc.core.dao.email.JavaEmailDao
mms.mail.transport=smtp
mms.mail.hostname=smtp.yaoxing.online
mms.mail.port=25
# mms.https.PEMKeyFile=/etc/pki/tls/server.pem
" | sudo tee -a /opt/mongodb/mms/conf/conf-mms.properties

sudo systemctl start mongod && sudo service mongodb-mms start