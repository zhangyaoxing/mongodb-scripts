#!/bin/bash
# add mongodb source
echo -e '[mongodb-enterprise-4.2]
name=MongoDB Enterprise Repository
baseurl=https://repo.mongodb.com/yum/redhat/$releasever/mongodb-enterprise/4.2/$basearch/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-4.2.asc
' > /etc/yum.repos.d/mongodb-ee-4.0.repo

yum install -y mongodb-enterprise 
mkdir -p /data/db
chown -R mongod:mongod /data
setenforce Permissive
sed -i 's%dbPath: /var/lib/mongo%dbPath: /data/db/%' /etc/mongod.conf

curl -O https://downloads.mongodb.com/on-prem-mms/rpm/mongodb-mms-4.2.16.56965.20200805T1936Z-1.x86_64.rpm
rpm -ivh mongodb-mms-4.2.16.56965.20200805T1936Z-1.x86_64.rpm

echo -e "
mms.fromEmailAddr=admin@yaoxing.online
mms.replyToEmailAddr=admin@yaoxing.online
mms.adminEmailAddr=admin@yaoxing.online
mms.emailDaoClass=com.xgen.svc.core.dao.email.JavaEmailDao
mms.mail.transport=smtp
mms.mail.hostname=smtp.yaoxing.online
mms.mail.port=25
" >> /opt/mongodb/mms/conf/conf-mms.properties

systemctl start mongod && service mongodb-mms start
