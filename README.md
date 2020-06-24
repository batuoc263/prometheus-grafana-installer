# Các file installer cho prometheus và grafana

Để tiết kiệm 1 chút thời gian trong phần cài đặt server, mình làm ra một số file này để các bạn triển khai server monitor được nhanh chóng hơn.

Đầu tiên, cần cấp quyền excute cho tất cả các file này bằng lệnh chmod

Cài đặt prometheus và grafana lên server bằng file `prometheus-grafana-installer.sh`

Để lấy được các metrics của các thiết bị mạng (thông qua snmp), cài đặt snmp_exporter lên prometheus server bằng file `snmp_exporter.sh`

Để lấy được các metrics của các thiết bị mạng (thông qua snmp), cài đặt vmware_exporter lên prometheus server bằng file `vmware_exporter.sh`

Để lấy được các metrics của các thiết bị mạng (thông qua snmp), cài đặt node_exporter_agent lên host linux bằng file `node_exporter_agent.sh`
