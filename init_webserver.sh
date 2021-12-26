#!/bin/bash

# Create mount volume for logs
  sudo su - root
  #mkfs.ext4 /dev/sdf
  #mount -t ext4 /dev/sdf /var/log

# Install & Start nginx server
  sudo mkdir -p /var/www/html/
  amazon-linux-extras install httpd mysql php php-mysql -y
  systemctl start httpd
  systemctl enable httpd

# Print the hostname which includes instance details on nginx homepage
  sudo mv /tmp/index.php /var/www/html/index.php
