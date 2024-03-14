#!/bin/bash

# Install firewall
apt install ufw

# Script to configure basic firewall settings using ufw on Ubuntu

echo "Starting firewall setup..."

# Default policy: deny all incoming traffic, allow all outgoing traffic
echo "Setting default policies..."
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Allow SSH connections to ensure remote management
echo "Allowing SSH..."
sudo ufw allow ssh

# Allow web server ports (HTTP/HTTPS)
echo "Allowing HTTP (80) and HTTPS (443)..."
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# For OpenLiteSpeed, allow the default server and WebAdmin console ports
echo "Allowing OpenLiteSpeed default port (8088) and WebAdmin console port (7080)..."
sudo ufw allow 8088/tcp
sudo ufw allow 7080/tcp

# Enable the firewall
echo "Enabling UFW (Uncomplicated Firewall)..."
echo "y" | sudo ufw enable

echo "Firewall setup completed."






