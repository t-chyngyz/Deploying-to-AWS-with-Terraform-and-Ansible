#!/bin/bash
database-host=${database_address}
database-username=${database_username}
database-password=${database_password}
database-database=${database_name}
# Install & Start nginx server
  sudo mkdir -p /var/www/html/
  sudo apt install apache2 php libapache2-mod-php php-mysql -y
  sudo wget https://raw.githubusercontent.com/t-chyngyz/Deploying-to-AWS-with-Terraform-and-Ansible/main/index.php -O /var/www/html/index.php
  echo '<?php phpinfo(); ?>' | sudo tee -a /var/www/html/index.php > /dev/null
  sudo sed -i 's/dbahost/$database-host/g' /var/www/html/index.php
  sudo sed -i 's/username/$database-username/g' /var/www/html/index.php
  sudo sed -i 's/password/$database-database/g' /var/www/html/index.php
  sudo sed -i 's/database/$database-database/g' /var/www/html/index.php
  sudo sed -i '2s/.*/'\\t' DirectoryIndex index.php/g' /etc/apache2/mods-available/dir.conf
  sudo systemctl restart apache2
  sudo systemctl enable apache2

