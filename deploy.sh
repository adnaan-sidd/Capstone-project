#!/bin/bash

# Update package manager
sudo apt update -y

# Install Docker
sudo apt install docker.io -y
sudo usermod -aG docker ubuntu

# Check if container with name "app" is running
if sudo docker ps -a --format '{{.Names}}' | grep -q "app"; then
  echo "Stopping and removing existing 'app' container..."
  sudo docker stop app
  sudo docker rm app
fi

# Run new container with name "app"
sudo docker run -d -p 80:80 --name app adnaansidd/prod:latest

