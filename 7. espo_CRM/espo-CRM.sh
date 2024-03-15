#!/bin/bash

# Update system packages
apt update && apt upgrade -y

# Install Apache2, MySQL, and PHP with necessary extensions
apt install -y apache2 default-mysql-server php php-cli php-common php-json php-mysql php-gd php-curl php-zip php-xml php-mbstring unzip wget

# Start and enable Apache2 and MySQL
systemctl start apache2
systemctl enable apache2
systemctl start mysql
systemctl enable mysql

# Secure MySQL installation automatically (Optional, manual recommended)
# echo -e "\n\nyour_mysql_root_password\nyour_mysql_root_password\n\n\n\n" | mysql_secure_installation

# MySQL commands to setup EspoCRM database
mysql -e "CREATE DATABASE espocrm_db CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;"
mysql -e "CREATE USER 'espocrm_user'@'localhost' IDENTIFIED BY 'espocrm_password';"
mysql -e "GRANT ALL PRIVILEGES ON espocrm_db.* TO 'espocrm_user'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"

# Download and install EspoCRM
cd /var/www/html
wget https://www.espocrm.com/downloads/EspoCRM-7.1.6.zip
unzip EspoCRM-7.1.6.zip
mv EspoCRM-7.1.6 espocrm
chown -R www-data:www-data espocrm

# Configure Apache2 for EspoCRM
cat > /etc/apache2/sites-available/espocrm.conf <<EOF
<VirtualHost *:80>
    ServerAdmin admin@your_domain
    ServerName your_domain
    DocumentRoot /var/www/html/espocrm

    <Directory /var/www/html/espocrm>
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF

# Enable site and mod_rewrite
a2ensite espocrm.conf
a2enmod rewrite

# Restart Apache2 to apply changes
systemctl restart apache2

echo "EspoCRM installation script has finished."
