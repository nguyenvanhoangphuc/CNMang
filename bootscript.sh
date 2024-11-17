#!/bin/bash
# Update hệ thống và cài đặt Apache2
sudo apt update
sudo apt install -y apache2
# Đảm bảo Apache2 tự động khởi động
sudo systemctl enable apache2
sudo systemctl start apache2
# Tạo trang index đơn giản
echo "Welcome to Web Server at $(hostname)" | sudo tee /var/www/html/index.html
