#!/bin/bash
microstack.openstack network create N1
microstack.openstack network list
microstack.openstack subnet create --network N1 --subnet-range 10.10.10.0/24 --gateway 10.10.10.1 --allocation-pool start=10.10.10.10,end=10.10.10.50 S1
microstack.openstack subnet list
microstack.openstack router create R1
microstack.openstack router list
microstack.openstack router set R1 --external-gateway external
microstack.openstack router add subnet R1 S1

microstack.openstack security group create webtraffic
microstack.openstack security group list

microstack.openstack security group rule create --ingress --protocol tcp --dst-port 80 --remote-ip 0.0.0.0/0 webtraffic
microstack.openstack security group rule create --ingress --protocol tcp --dst-port 22 --remote-ip 0.0.0.0/24 webtraffic
microstack.openstack security group rule list webtraffic

microstack.openstack port create --network N1 --fixed-ip subnet=S1,ip-address=10.10.10.100 --security-group webtraffic port-N1

microstack.openstack keypair create keyCuong > keyCuong.pem
chmod 400 keyCuong.pem

# Lấy IP của port có name là "port-N1"
PORT_IP=$(microstack.openstack port list -c Name -c "Fixed IP Addresses" -f value | grep "port-N1" | awk '{print $2}' | sed 's/[{}]//g' | awk -F= '{print $2}')

# Kiểm tra nếu PORT_IP không rỗng
if [ -n "$PORT_IP" ]; then
    echo "IP của port-N1: $PORT_IP"
    # Tạo server với IP của port-N1
    sudo microstack.openstack server create --flavor m1.small --image ubuntu10 --key-name keyCuong --security-group webtraffic --nic net-id="$PORT_IP" Web-Server
else
    echo "Không tìm thấy port có name 'port-N1'."
fi