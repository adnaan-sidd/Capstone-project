#!/bin/bash

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
  # Docker is not installed, so update package manager and install Docker
  echo "Installing Docker..."
  sudo apt update -y
  sudo apt install docker.io -y
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
docker login -u adnaansidd -p 26122001As@
sudo docker pull adnaansidd/prod:latest
sudo docker run -d -p 80:80 --name app adnaansidd/prod:latest
