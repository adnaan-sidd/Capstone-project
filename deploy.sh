#!/bin/bash

# Update package manager
sudo yum update -y

# Install Docker
sudo amazon-linux-extras install docker -y
sudo service docker start
sudo usermod -aG docker ec2-user

# Optional: Start Docker on boot
sudo chkconfig docker on

# Check if container with name "app" is running
if sudo docker ps -a --format '{{.Names}}' | grep -q "app"; then
  echo "Stopping and removing existing 'app' container..."
  sudo docker stop app
  sudo docker rm app
fi

# Run new container with name "app"
sudo docker run -d -p 80:80 --name app adnaansidd/prod:latest

