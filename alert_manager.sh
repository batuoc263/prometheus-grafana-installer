#!/bin/bash

echo "=========Install AlertManager=========="

wget https://github.com/prometheus/alertmanager/releases/download/v0.20.0/alertmanager-0.20.0.linux-amd64.tar.gz

tar -xvzf alertmanager-0.20.0.linux-amd64.tar.gz

mv alertmanager-0.20.0.linux-amd64 /usr/local/alertmanager

touch /etc/systemd/system/alertmanager.service

echo "[Unit]
Description=AlertManager
Wants=network-online.target
After=network-online.target

[Service]
User=root
Group=root
Type=simple
ExecStart=/usr/local/alertmanager/alertmanager \
--config.file=/usr/local/alertmanager/alertmanager.yml

[Install]
WantedBy=multi-user.target" >> /etc/systemd/system/alertmanager.service

systemctl daemon-reload

systemctl enable alertmanager

systemctl restart alertmanager

iptables -A INPUT -p tcp -m tcp --dport 9093 -j ACCEPT
service iptables save


echo "Example: windows rules from ITFORVN"

touch /usr/local/prometheus/windows-rules.yml

echo '############# Define Rule Alert ###############
# my global config

############# Define Rule Alert ###############
groups:
- name: Windows-alert
  rules:

################ Memory Usage High
  - alert: Memory Usage High
    expr: 100*(wmi_os_physical_memory_free_bytes) / wmi_cs_physical_memory_bytes > 90
    for: 1m
    labels:
      severity: warning
    annotations:
      summary: "Memory Usage (instance {{ $labels.instance }})"
      description: "Memory Usage is more than 90%\n  VALUE = {{ $value }}\n  LABELS: {{ $labels }}"

################ CPU Usage High
  - alert: Cpu Usage High
    expr: 100 - (avg by (instance) (irate(wmi_cpu_time_total{mode="idle"}[2m])) * 100) > 80
    for: 1m
    labels:
      severity: warning
    annotations:
      summary: "CPU Usage (instance {{ $labels.instance }})"
      description: "CPU Usage is more than 80%\n  VALUE = {{ $value }}\n  LABELS: {{ $labels }}"

################ Disk Usage
  - alert: DiskSpaceUsage
    expr: 100.0 - 100 * ((wmi_logical_disk_free_bytes{} / 1024 / 1024 ) / (wmi_logical_disk_size_bytes{}  / 1024 / 1024)) > 95
    for: 1m
    labels:
      severity: error
    annotations:
      summary: "Disk Space Usage (instance {{ $labels.instance }})"
      description: "Disk Space on Drive is used more than 95%\n  VALUE = {{ $value }}\n  LABELS: {{ $labels }}"

################ ServiceStatus
  - alert: ServiceStatus
    expr: wmi_service_status{status="ok"} != 1
    for: 1m
    labels:
      severity: error
    annotations:
      summary: "Service Status (instance {{ $labels.instance }})"
      description: "Windows Service state is not OK\n  VALUE = {{ $value }}\n  LABELS: {{ $labels }}"

################ CollectorError
  - alert: CollectorError
    expr: wmi_exporter_collector_success == 0
    for: 1m
    labels:
      severity: error
    annotations:
      summary: "Collector Error (instance {{ $labels.instance }})"
      description: "Collector {{ $labels.collector }} was not successful\n  VALUE = {{ $value }}\n  LABELS: {{ $labels }}"' >> /usr/local/prometheus/windows-rules.yml

sed -i '/rule_files:/a \  - "windows-rules.yml"' /usr/local/prometheus/prometheus.yml

echo "Notice: You need to edit your target (- ip_prometheus:9093) at /usr/local/prometheus/prometheus.yml:12 and check windows-rules.yml (rule-files) after rulefile prometheus.yml:15"

cd ${GOPATH-$HOME/go}/src/github.com

go get github.com/inCaller/prometheus_bot

cd ${GOPATH-$HOME/go}/src/github.com/inCaller/prometheus_bot

make clean

make

mv /root/go/src/github.com/inCaller/prometheus_bot /usr/local

touch /usr/local/prometheus_bot/config.yaml

read -p "Enter your telegram bot token : " token

echo "telegram_token: \"$token\"

# ONLY IF YOU USING TEMPLATE required for test

 

template_path: \"template.tmpl\"

time_zone: \"Asia/Ho_Chi_Minh\"

split_token: \"|\"

 

# ONLY IF YOU USING DATA FORMATTING FUNCTION, NOTE for developer: important or test fail

time_outdata: \"02/01/2006 15:04:05\"

split_msg_byte: 4000" >> /usr/local/prometheus_bot/config.yaml

vi /usr/local/alertmanager/alertmanager.yml

read -p "Enter your telegram chat group id (ex: -53527615) : " chatid
export TELEGRAM_CHATID="$chatid"