#!/bin/bash
DATABASEHOST=${database_host}
DATABASEUSERNAME=${database_username}
DATABASEPASSWORD=${database_password}
DATABASENAME=${database_name}
# Install & Start nginx server
  sudo mkdir -p /var/www/html/
  sudo apt install apache2 php libapache2-mod-php php-mysql -y
  sudo wget https://raw.githubusercontent.com/t-chyngyz/Deploying-to-AWS-with-Terraform-and-Ansible/main/index.php -O /var/www/html/index.php
  echo '<?php phpinfo(); ?>' | sudo tee -a /var/www/html/index.php > /dev/null
  sudo sed -i 's/dbahost/'$DATABASEHOST'/g' /var/www/html/index.php
  sudo sed -i 's/username/'$DATABASEUSERNAME'/g' /var/www/html/index.php
  sudo sed -i 's/password/'$DATABASEPASSWORD'/g' /var/www/html/index.php
  sudo sed -i 's/database/'$DATABASENAME'/g' /var/www/html/index.php
  sudo sed -i '2s/.*/'\\t' DirectoryIndex index.php/g' /etc/apache2/mods-available/dir.conf
  sudo systemctl restart apache2
  sudo systemctl enable apache2
