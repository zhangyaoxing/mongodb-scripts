#!/bin/bash
# add mongodb source
echo -e '
[mongodb-enterprise-8.0]
name=MongoDB Enterprise Repository
baseurl=https://repo.mongodb.com/yum/amazon/2023/mongodb-enterprise/8.0/$basearch/
gpgcheck=1
enabled=1
gpgkey=https://pgp.mongodb.com/server-8.0.asc
' > /etc/yum.repos.d/mongodb-enterprise-8.0.repo

yum install -y mongodb-enterprise 
mkdir -p /data/db
chown -R mongod:mongod /data
setenforce Permissive
sed -i 's%SELINUX=enforcing%SELINUX=permissive%' /etc/selinux/config
sed -i 's%dbPath: /var/lib/mongo%dbPath: /data/db/%' /etc/mongod.conf

# Download & install Ops Manager
curl -O https://downloads.mongodb.com/on-prem-mms/rpm/mongodb-mms-8.0.0.500.20240924T1611Z.x86_64.rpm
rpm -ivh mongodb-mms-8.0.0.500.20240924T1611Z.x86_64.rpm

echo -e "
mms.fromEmailAddr=admin@yaoxing.online
mms.replyToEmailAddr=admin@yaoxing.online
mms.adminEmailAddr=admin@yaoxing.online
mms.emailDaoClass=com.xgen.svc.core.dao.email.JavaEmailDao
mms.mail.transport=smtp
mms.mail.hostname=smtp.yaoxing.online
mms.mail.port=25
# mms.https.PEMKeyFile=/etc/pki/tls/server.pem
" >> /opt/mongodb/mms/conf/conf-mms.properties

systemctl start mongod && service mongodb-mms start