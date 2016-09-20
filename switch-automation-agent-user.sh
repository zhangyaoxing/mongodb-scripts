SERVICE_USER="ec2-user"
SERVICE_GROUP="users"
service mongodb-mms-automation-agent stop
chown -R $SERVICE_USER:$SERVICE_GROUP /data/
chown -R $SERVICE_USER:$SERVICE_GROUP /var/log/mongodb-mms-automation/
chown -R $SERVICE_USER:$SERVICE_GROUP /etc/mongodb-mms/
sed -i 's/SERVICE_USER="mongod"/SERVICE_USER="'$SERVICE_USER'"\nSERVICE_GROUP="'$SERVICE_GROUP'"/g' /etc/init.d/mongodb-mms-automation-agent
sed -i 's/-g $SERVICE_USER/-g $SERVICE_GROUP/g' /etc/init.d/mongodb-mms-automation-agent
service mongodb-mms-automation-agent start
