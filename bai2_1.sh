#!/bin/bash
sudo apt update
sudo apt upgrade
sudo snap install microstack --beta
sudo microstack init --auto --control
microstack.openstack --version
sudo snap get microstack
PASSWORD=$(sudo snap get microstack config.credentials.keystone-password)
echo "Keystone Password: $PASSWORD"
# Lấy danh sách địa chỉ IPv4
IPV4_ADDRESSES=$(ip -4 a | grep inet | awk '{print $2}' | cut -d'/' -f1)
echo "IPv4 Addresses:"
echo "$IPV4_ADDRESSES"