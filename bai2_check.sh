#!/bin/bash
set -e

# Update system and install curl
echo "Updating system and installing curl..."
sudo apt update
sudo apt install -y curl

# Check the status of SSH service
echo "Checking the status of SSH service..."
sudo systemctl status sshd || echo "SSH service is not installed, installing it now."

# Install and configure OpenSSH server
echo "Installing and configuring OpenSSH server..."
sudo apt install -y openssh-server

# Check the status of SSH service again
echo "Checking the status of SSH service again..."
sudo systemctl status ssh

# Start and enable SSH service
echo "Starting and enabling SSH service..."
sudo systemctl start ssh
sudo systemctl enable ssh

# Check HTTP connection to floating IP address
echo "Checking HTTP connection to floating IP 10.20.20.122..."
curl http://10.20.20.122

# Check SSH connection to floating IP address
echo "Checking SSH connection to floating IP 10.20.20.122..."
ssh -i keyCuong.pem root@10.20.20.122 "echo 'SSH successful!'"

# Check ping connection to floating IP address with time limit (Expected to fail)
echo "Checking ping connection to floating IP 10.20.20.122 with time limit of 10 seconds..."
ping -c 4 -w 10 10.20.20.122 || echo "Ping failed as expected, ping to floating IP is not allowed."
