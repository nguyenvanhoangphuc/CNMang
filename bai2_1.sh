#!/bin/bash
set -e  # Dừng script nếu có lỗi xảy ra
sudo apt update
sudo apt upgrade -y

# Cài đặt Snap nếu chưa có
if ! command -v snap &> /dev/null; then
    sudo apt install snapd -y
fi

# Cài đặt MicroStack và khởi tạo
sudo snap install microstack --beta
sudo microstack init --auto --control

# Kiểm tra phiên bản và lấy thông tin Keystone Password
microstack.openstack --version
PASSWORD=$(sudo snap get microstack config.credentials.keystone-password)
echo "Keystone Password: $PASSWORD"

# Lấy danh sách địa chỉ IPv4
IPV4_ADDRESSES=$(ip -4 a | grep inet | awk '{print $2}' | cut -d'/' -f1)
echo "IPv4 Addresses:"
echo "$IPV4_ADDRESSES"
