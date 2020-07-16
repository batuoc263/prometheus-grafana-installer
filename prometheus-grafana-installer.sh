#!/bin/bash

echo "=========Install Iptables=========="

systemctl stop firewalld

systemctl disable firewalld

systemctl mask –now firewalld

yum install iptables-services -y

systemctl start iptables

systemctl enable iptables

echo "Open port 22, 3000, 9090" 
iptables -F
iptables -A INPUT -p tcp -m tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 3000 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 9090 -j ACCEPT
service iptables save

echo "=========Install Prometheus=========="
wget https://github.com/prometheus/prometheus/releases/download/v2.19.0/prometheus-2.19.0.linux-amd64.tar.gz

tar -xvzf prometheus-2.19.0.linux-amd64.tar.gz

mv prometheus-2.19.0.linux-amd64 /usr/local/prometheus/

touch /etc/systemd/system/prometheus.service

echo "[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=root
Group=root
Type=simple
ExecStart=/usr/local/prometheus/prometheus \
--config.file /usr/local/prometheus/prometheus.yml \
--storage.tsdb.path /usr/local/prometheus/ \
--web.console.templates=/usr/local/prometheus/consoles \
--web.console.libraries=/usr/local/prometheus/console_libraries

[Install]
WantedBy=multi-user.target" >> /etc/systemd/system/prometheus.service

systemctl daemon-reload

systemctl start prometheus

systemctl status prometheus

echo "===========Install Grafana==========="

wget https://dl.grafana.com/oss/release/grafana-7.0.3-1.x86_64.rpm

yum install grafana-7.0.3-1.x86_64.rpm

systemctl daemon-reload

systemctl start grafana-server

systemctl enable grafana-server

systemctl status grafana-server
