#!/bin/bash

# Update and install Docker
sudo apt update
sudo apt install docker.io -y

# Add current user to the Docker group
sudo usermod -aG docker $USER

# Apply group changes without logout
newgrp docker

# Check Docker version
docker --version

# Install curl and wget
sudo apt install curl wget -y

# Install Docker Compose
sudo apt install docker-compose -y

# Start Docker services
sudo systemctl start docker
sudo systemctl enable docker

# Create directories for MongoDB, Elasticsearch, and Graylog
sudo mkdir -p /mongo_data
sudo mkdir -p /es_data
sudo mkdir -p /graylog_journal

# Set permissions on directories
sudo chmod 777 -R /mongo_data
sudo chmod 777 -R /es_data
sudo chmod 777 -R /graylog_journal

# Allow traffic on port 9000
sudo ufw allow 9000/tcp

echo "Setup completed."
