#!/bin/bash

echo "===========Install Python3==========="
wget https://www.python.org/ftp/python/3.6.4/Python-3.6.4.tar.xz

tar -xJf Python-3.6.4.tar.xz

cd Python-3.6.4

./configure

make

make install

pip3 install --upgrade pip

pip3 install vmware_exporter

echo "Open port 9272"
iptables -A INPUT -p tcp -m tcp --dport 9272 -j ACCEPT
service iptables save

cd /usr/local/lib/python3.6/site-packages/vmware_exporter

echo -n "Enter the Esxi ip: "
read vsphere_host

echo -n "Enter the Esxi monitor user: "
read vsphere_user

echo -n "Enter the Esxi monitor password: "
read vsphere_password

touch config.yml

echo "default:
  vsphere_host: $vsphere_host
  vsphere_user: '$vsphere_user'
  vsphere_password: '$vsphere_password'
  ignore_ssl: True
  specs_size: 5000
  collect_only:
    vms: True
    vmguests: False
    datastores: True
    hosts: True
    snapshots: True" >>config.yml

cp /usr/local/lib/python3.6/site-packages/vmware_exporter /usr/local/bin/

touch /etc/systemd/system/vmware_exporter.service

echo "[Unit]
Description=Prometheus VMWare Exporter
After=network.target

[Service]
User=root
Group=root
ExecStart=/bin/bash -c 'python3 /usr/local/bin/vmware_exporter -c /usr/local/lib/python3.6/site-packages/vmware_exporter/config.yml'
Type=simple

[Install]
WantedBy=multi-user.target" >> /etc/systemd/system/vmware_exporter.service

systemctl enable vmware_exporter.service

systemctl start vmware_exporter.service
