#!/usr/bin/env bash

set -eux

yum makecache

# install additional packasge
yum install -y \
    fio \
    irqbalance \
    bash-completion \
    bind-utils \
    hostname \
    qemu-guest-agent \
    cloud-init \
    cloud-utils-growpart \
    yum-utils \
    network-scripts \
    dhcp-client \
    nfs-utils \
    cifs-utils \
    python3-openstackclient \
    kubernetes-client \
    mariadb \
    postgresql \
    redis \
    mongodb-org-shell \
    iperf3 \
    conntrack-tools \
    telnet \
    s3fs-fuse \
    mc

wget https://github.com/jqlang/jq/releases/download/jq-1.7/jq-linux-amd64 -O /usr/local/bin/jq
chmod 755 /usr/local/bin/jq

cd /root
curl https://clickhouse.com/ | sh
sudo ./clickhouse install -y
rm -rf ./clickhouse

unset https_proxy

# Configure kernel params
sed '/GRUB_CMDLINE_LINUX/d' -i /etc/default/grub
echo 'GRUB_CMDLINE_LINUX="plymouth.enable=0 console=ttyS0,115200n8 console=tty0 LANG=C.UTF-8 net.ifnames=0 selinux=0"' >> /etc/default/grub
echo 'GRUB_SERIAL_COMMAND="serial --speed=115200 --unit=0 --word=8 --parity=no --stop=1"' >> /etc/default/grub
grub2-mkconfig -o /boot/grub2/grub.cfg

# Disable selinux
echo "SELINUX=disabled" > /etc/selinux/config
echo "SELINUXTYPE=targeted" >> /etc/selinux/config


# yum cleanup
yum clean all
yum history new

# enable services
systemctl enable qemu-guest-agent network cloud-init cloud-init-local cloud-config cloud-final

# set dhcp timeout
echo "timeout 900;" >> /etc/dhcp/dhclient.conf

# For cloud-init
cat << EOF >> /etc/cloud/cloud.cfg
   default_user:
     name: redos
EOF
