#!/bin/bash

set -e  # Dừng script nếu có lệnh nào lỗi

# 1. Đặt gateway cho router
echo "Setting external gateway for router R1..."
microstack.openstack router set --external-gateway external R1

# 2. Bật IP forwarding
echo "Enabling IP forwarding..."
sudo sysctl -w net.ipv4.ip_forward=1

# 3. Cấu hình NAT (MASQUERADE) trên interface ens33
echo "Configuring NAT (MASQUERADE) on interface ens33..."
sudo iptables -t nat -A POSTROUTING -o ens33 -j MASQUERADE

# 4. Tải bootscript.sh và đặt quyền
echo "Downloading bootscript.sh..."
wget -q https://raw.githubusercontent.com/nguyenvanhoangphuc/CNMang/main/bootscript.sh -O bootscript.sh

echo "Moving bootscript.sh to /snap/microstack/ and setting permissions..."
sudo mv bootscript.sh /snap/microstack/
sudo chmod +r /snap/microstack/bootscript.sh

# 5. Tạo server mới với script khởi động
echo "Creating a new server Web-Server..."
PORT_ID=$(microstack.openstack port list | grep port-N1 | awk '{print $2}')
microstack.openstack server create \
  --flavor m1.small \
  --image "ubuntu16" \
  --key-name keyCuong \
  --security-group webtraffic \
  --nic port-id=$PORT_ID \
  --user-data /snap/microstack/bootscript.sh \
  Web-Server

# 6. Tạo Floating IP
echo "Creating a floating IP..."
# Tạo floating IP và lưu ID vào biến
FLOATING_IP_ID=$(microstack.openstack floating ip create external -f value -c id)
# Lấy địa chỉ IP của floating IP và lưu vào biến
FLOATING_IP_ADDRESS=$(microstack.openstack floating ip show $FLOATING_IP_ID -f value -c floating_ip_address)
# In ra ID và địa chỉ của floating IP
echo "Floating IP ID: $FLOATING_IP_ID"
echo "Floating IP Address: $FLOATING_IP_ADDRESS"

# 7. Liên kết Floating IP với server
echo "Associating floating IP with server..."
microstack.openstack floating ip set --port $PORT_ID $FLOATING_IP_ID

# Kết thúc
echo "Script execution completed!"
