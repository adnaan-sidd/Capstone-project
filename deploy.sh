#!/bin/bash

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
  # Docker is not installed, so update package manager and install Docker
  echo "Installing Docker..."
 sudo apt update
sudo apt install ca-certificates curl gnupg

sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
sudo apt install docker-compose -y

sudo service docker restart
sudo chmod 666 /var/run/docker.sock
sudo systemctl restart docker

else
  echo "Docker is already installed."
fi

# Check if container with name "app" is running
if sudo docker ps -a --format '{{.Names}}' | grep -q "app"; then
  echo "Stopping and removing existing 'app' container..."
  sudo docker stop app
  sudo docker rm app
fi

# Run a new container with the name "app"
sudo docker run -d -p 80:80 --name app adnaansidd/prod:latest
