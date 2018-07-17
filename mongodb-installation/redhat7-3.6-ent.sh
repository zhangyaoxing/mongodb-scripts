# add mongodb source
echo -e '[mongodb-enterprise]
name=MongoDB Enterprise Repository
baseurl=https://repo.mongodb.com/yum/redhat/$releasever/mongodb-enterprise/3.6/$basearch/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-3.6.asc' > /etc/yum.repos.d/mongodb-ee-3.6.repo

yum install -y mongodb-enterprise 
mkdir -p /data/db
openssl rand -base64 756 > /data/keyfile
chmod 400 /data/keyfile
chown -R mongod:mongod /data
setenforce Permissive

# change configuration
sed -i "s/bindIp: 127.0.0.1 /bindIp: 127.0.0.1,`ifconfig | grep 'inet ' | grep -v 127 | grep -Po '(?<=inet )\d+.\d+.\d+.\d+'` /" /etc/mongod.conf
sed -i 's/#replication:/replication:\n  replSetName: rs/' /etc/mongod.conf
sed -i 's%#security:%security:\n  authorization: enabled\n  keyFile: /data/keyfile%' /etc/mongod.conf
sed -i 's%dbPath: /var/lib/mongo%dbPath: /data/db/%' /etc/mongod.conf

