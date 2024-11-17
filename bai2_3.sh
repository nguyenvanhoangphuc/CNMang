#!/bin/bash

set -e  # Dừng script nếu có lệnh nào lỗi

# # 1. Đặt gateway cho router
# echo "Setting external gateway for router R1..."
# microstack.openstack router set --external-gateway external R1

# # 2. Bật IP forwarding
# echo "Enabling IP forwarding..."
# sudo sysctl -w net.ipv4.ip_forward=1

# # 3. Cấu hình NAT (MASQUERADE) trên interface ens33
# echo "Configuring NAT (MASQUERADE) on interface ens33..."
# sudo iptables -t nat -A POSTROUTING -o ens33 -j MASQUERADE

# # 4. Tải bootscript.sh và đặt quyền
# echo "Downloading bootscript.sh..."
# wget -q https://raw.githubusercontent.com/nguyenvanhoangphuc/CNMang/main/bootscript.sh -O bootscript.sh

# echo "Moving bootscript.sh to /snap/microstack/ and setting permissions..."
# sudo mv bootscript.sh /snap/microstack/
# sudo chmod +r /snap/microstack/bootscript.sh

# # 5. Tạo server mới với script khởi động
# echo "Creating a new server Web-Server..."
# PORT_ID="4b565237-d4f7-4046-b2a5-5dc3500aeed1"  # Thay port-id bằng giá trị phù hợp
# microstack.openstack server create \
#   --flavor m1.small \
#   --image "ubuntu10" \
#   --key-name keyCuong \
#   --security-group webtraffic \
#   --nic port-id=$PORT_ID \
#   --user-data /snap/microstack/bootscript.sh \
#   Web-Server

# 6. Tạo Floating IP
echo "Creating a floating IP..."
# Tạo một floating IP mới và lấy ID của nó
FLOATING_IP_ID=$(microstack.openstack floating ip create external -f value -c id)
# Lấy địa chỉ IP của floating IP vừa tạo
FLOATING_IP=$(microstack.openstack floating ip list -f value -c "Floating IP Address" | tail -n1)
echo "Floating IP Address: $FLOATING_IP"

# 7. Liên kết Floating IP với server
echo "Associating floating IP with server..."
SERVER_PORT_ID=$(microstack.openstack port list -c ID -c "Device Owner" -f value | grep compute: | awk '{print $1}')
microstack.openstack floating ip set --port $SERVER_PORT_ID $FLOATING_IP

# Kết thúc
echo "Script execution completed!"
