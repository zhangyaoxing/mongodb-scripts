yum install -y numactl
sudo mkdir /etc/tuned/no-thp
echo -e '[main]
include=virtual-guest

[vm]
transparent_hugepages=never' > /etc/tuned/no-thp/tuned.conf 

# diable thp
tuned-adm profile no-thp
cat /sys/kernel/mm/transparent_hugepage/enabled
cat /sys/kernel/mm/transparent_hugepage/defrag
