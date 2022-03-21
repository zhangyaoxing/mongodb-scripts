#!/bin/bash
# add mongodb source
echo -e '
[mongodb-enterprise-4.4]
name=MongoDB Enterprise Repository
baseurl=https://repo.mongodb.com/yum/redhat/$releasever/mongodb-enterprise/4.4/$basearch/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-4.4.asc
' > /etc/yum.repos.d/mongodb-enterprise-4.4.repo

yum install -y mongodb-enterprise 
mkdir -p /data/db
chown -R mongod:mongod /data
setenforce Permissive
sed -i 's%dbPath: /var/lib/mongo%dbPath: /data/db/%' /etc/mongod.conf

# Download & install Ops Manager
curl -O https://downloads.mongodb.com/on-prem-mms/rpm/mongodb-mms-4.4.5.103.20201104T1729Z-1.x86_64.rpm
rpm -ivh mongodb-mms-4.4.5.103.20201104T1729Z-1.x86_64.rpm

# Sign HTTPS certificate
openssl genrsa -out rootCA.key 4096 
openssl req -x509 -new -nodes -key rootCA.key -days 365 -out rootCA.crt -config ca-x509.config
openssl genrsa -out server.key 4096 
openssl req -new -key server.key -out server.csr -config x509.config
openssl x509 -req -in server.csr \
  -CA rootCA.crt \
  -CAkey rootCA.key \
  -CAcreateserial \
  -out server.crt \
  -days 365 \
  -extensions req_ext \
  -extfile x509.config
cat server.crt server.key > /etc/pki/tls/server.pem
chown mongodb-mms: /etc/pki/tls/server.pem
chmod 600 /etc/pki/tls/server.pem
cp rootCA.crt /etc/pki/ca-trust/

echo -e "
mms.fromEmailAddr=admin@yaoxing.online
mms.replyToEmailAddr=admin@yaoxing.online
mms.adminEmailAddr=admin@yaoxing.online
mms.emailDaoClass=com.xgen.svc.core.dao.email.JavaEmailDao
mms.mail.transport=smtp
mms.mail.hostname=smtp.yaoxing.online
mms.mail.port=25
mms.https.PEMKeyFile=/etc/pki/tls/server.pem
" >> /opt/mongodb/mms/conf/conf-mms.properties

systemctl start mongod && service mongodb-mms start
