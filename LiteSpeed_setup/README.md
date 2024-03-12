# OpenLiteSpeed Installation Script

This repository contains a shell script for the easy installation of OpenLiteSpeed and LSAPI PHP on Ubuntu servers. OpenLiteSpeed is a high-performance, lightweight, and scalable web server with an admin-friendly web interface.

## Prerequisites

- A Ubuntu server (18.04 LTS or later is recommended).
- Root or sudo access to the server.

## Installation Steps

1. **Create New Script File**
```
  nano install_openlitespeed.sh
```
2. **Copy and paste the following script**
```
#!/bin/bash

# Update the system
echo "Updating system..."
sudo apt-get update && sudo apt-get upgrade -y

# Add OpenLiteSpeed repository
echo "Adding OpenLiteSpeed repository..."
wget -O - http://rpms.litespeedtech.com/debian/enable_lst_debian_repo.sh | sudo bash

# Install OpenLiteSpeed
echo "Installing OpenLiteSpeed..."
sudo apt-get install openlitespeed -y

# Install PHP for OpenLiteSpeed
echo "Installing LSAPI PHP..."
sudo apt-get install lsphp74 lsphp74-common lsphp74-mysql lsphp74-imap lsphp74-curl lsphp74-opcache -y

# Start OpenLiteSpeed
echo "Starting OpenLiteSpeed..."
sudo /usr/local/lsws/bin/lswsctrl start

# Set OpenLiteSpeed admin password
echo "Setting OpenLiteSpeed admin password..."
sudo /usr/local/lsws/admin/misc/admpass.sh

# Start OpenLiteSpeed and Access the WebAdmin Console
sudo /usr/local/lsws/bin/lswsctrl start

# Firewall Configuration
sudo ufw allow 8088
sudo ufw allow 7080


echo "OpenLiteSpeed installation and basic configuration completed."

```


3. **Make the script executable:**
```
chmod +x install_openlitespeed.sh

```

4.  **Make the script executable:**
```
 ./install_openlitespeed.sh

```   
