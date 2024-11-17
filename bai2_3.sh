#!/bin/bash
microstack.openstack router set --external-gateway external R1
sudo sysctl -w net.ipv4.ip_forward=1
sudo iptables -t nat -A POSTROUTING -o ens33 -j MASQUERADE
wget https://raw.githubusercontent.com/nguyenvanhoangphuc/CNMang/main/bootscript.sh -O bootscript.sh
sudo mv bootscript.sh /snap/microstack/
sudo chmod +r /snap/microstack/bootscript.sh
microstack.openstack server create --flavor m1.small --image "ubuntu16" --key-name keyCuong --security-group webtraffic --nic port-id=4b565237-d4f7-4046-b2a5-5dc3500aeed1 --user-data /snap/microstack/bootscript.sh Web-Server

microstack.openstack floating ip create external
sudo microstack.openstack floating ip list
sudo snap install openstackclients 
microstack.openstack floating ip set --port <port_id> <float_ip_id>

curl 10.20.20.57
ping 10.20.20.57
ssh -i keyCuong.pem root@10.20.20.57