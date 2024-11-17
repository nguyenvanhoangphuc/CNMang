#!/bin/bash
set -e

# Cập nhật hệ thống và cài đặt Apache
apt-get update
apt-get -y install apache2 openssh-server

# Cấu hình Apache với HTTPS
a2enmod ssl
a2ensite default-ssl
systemctl restart apache2

# Tạo trang chủ đơn giản hiển thị hostname
echo "$(hostname)" > /var/www/html/index.html

# Bật và khởi động dịch vụ SSH
systemctl enable ssh
systemctl start ssh

# Cấu hình tường lửa (ufw)
ufw allow 22/tcp   # Mở cổng SSH
ufw allow 80/tcp   # Mở cổng HTTP
ufw allow 443/tcp  # Mở cổng HTTPS
ufw enable
