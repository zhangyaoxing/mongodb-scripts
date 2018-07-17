#!/bin/bash
echo '#!/bin/bash
### BEGIN INIT INFO
# Provides:          disable-transparent-hugepages
# Required-Start:    $local_fs
# Required-Stop:
# X-Start-Before:    mongod mongodb-mms-automation-agent
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Disable Linux transparent huge pages
# Description:       Disable Linux transparent huge pages, to improve
#                    database performance.
### END INIT INFO

case $1 in
  start)
    if [ -d /sys/kernel/mm/transparent_hugepage ]; then
      thp_path=/sys/kernel/mm/transparent_hugepage
    elif [ -d /sys/kernel/mm/redhat_transparent_hugepage ]; then
      thp_path=/sys/kernel/mm/redhat_transparent_hugepage
    else
      return 0
    fi

    echo never > ${thp_path}/enabled
    echo never > ${thp_path}/defrag

    re='"'"'^[0-1]+$'"'"'
    if [[ $(cat ${thp_path}/khugepaged/defrag) =~ $re ]]
    then
      # RHEL 7
      echo 0  > ${thp_path}/khugepaged/defrag
    else
      # RHEL 6
      echo no > ${thp_path}/khugepaged/defrag
    fi

    unset re
    unset thp_path
    ;;
esac' | sudo tee -a /etc/init.d/disable-transparent-hugepages
chkconfig --add disable-transparent-hugepages
chkconfig disable-transparent-hugepages on
chmod 755 /etc/init.d/disable-transparent-hugepages
service disable-transparent-hugepages start
setenforce Permissive
sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config

cat /sys/kernel/mm/transparent_hugepage/enabled
cat /sys/kernel/mm/transparent_hugepage/defrag

echo '#!/bin/bash
### BEGIN INIT INFO
# Provides:          disable-ra
# Required-Start:    $local_fs
# Required-Stop:
# X-Start-Before:    mongod mongodb-mms-automation-agent
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Disable readahead
# Description:       Disable readahead to improve database performance.
### END INIT INFO
case $1 in
  start)
    blockdev --setra 0 <mongodb data volume>
    ;;
esac' | sudo tee -a /etc/init.d/disable-ra
sudo chmod 755 /etc/init.d/disable-ra
sudo chkconfig --add disable-ra
sudo chkconfig disable-ra on
sudo service disable-ra start