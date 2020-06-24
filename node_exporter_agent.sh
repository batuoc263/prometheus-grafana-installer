#!/bin/bash

echo "===========Install node_exporter============"
wget https://github.com/prometheus/node_exporter/releases/download/v1.0.0-rc.1/node_exporter-1.0.0-rc.1.linux-amd64.tar.gz

tar -xvzf node_exporter-1.0.0-rc.1.linux-amd64.tar.gz

mkdir /usr/local/node_exporter

mv node_exporter-1.0.0-rc.1.linux-amd64/node_exporter /usr/local/node_exporter

touch /etc/systemd/system/node_exporter.service

echo "[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=root
ExecStart=/usr/local/node_exporter/node_exporter

[Install]
WantedBy=default.target" >> /etc/systemd/system/node_exporter.service

systemctl daemon-reload
systemctl start node_exporter
systemctl enable node_exporter

echo "Visit http://host_ip:9100/metrics to verify"