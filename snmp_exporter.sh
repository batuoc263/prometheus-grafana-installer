#!/bin/bash


echo "===========Install Golang============"

wget https://dl.google.com/go/go1.14.4.linux-amd64.tar.gz

tar -xvzf go1.14.4.linux-amd64.tar.gz

mv go /usr/local

export GOROOT=/usr/local/go

export GOPATH=$HOME/go

export PATH=$GOPATH/bin:$GOROOT/bin:$PATH

go version

# RHEL-based distros
yum install git zip unzip gcc gcc-g++ make net-snmp net-snmp-utils net-snmp-libs net-snmp-devel 

echo "export GOROOT=/usr/local/go

export GOPATH=$HOME/go

export PATH=$GOPATH/bin:$GOROOT/bin:$PATH" >> ~/.bashrc

echo "===========Install smnp_exporter==========="
echo "Open port 9116"
iptables -A INPUT -p tcp -m tcp --dport 9116 -j ACCEPT
service iptables save

go get github.com/prometheus/snmp_exporter/tree/master/generator

cd ${GOPATH-$HOME/go}/src/github.com/prometheus/snmp_exporter/generator

go build

make mibs

wget https://github.com/prometheus/snmp_exporter/releases/download/v0.15.0/snmp_exporter-0.15.0.linux-amd64.tar.gz

tar -xvzf snmp_exporter-0.15.0.linux-amd64.tar.gz

mv snmp_exporter* /usr/local/snmp_exporter

touch /etc/systemd/system/snmp_exporter.service

echo "[Unit]
Description=Snmp_exporter
Wants=network-online.target
After=network-online.target

[Service]
User=root
Group=root
Type=simple
ExecStart=/usr/local/snmp_exporter/snmp_exporter \
--config.file=/usr/local/snmp_exporter/snmp.yml

[Install]
WantedBy=multi-user.target" >> /etc/systemd/system/snmp_exporter.service

systemctl start snmp_exporter.service

systemctl status snmp_exporter.service

systemctl enable snmp_exporter.service