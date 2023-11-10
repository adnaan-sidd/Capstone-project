#!/bin/bash

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
  # Docker is not installed, so update package manager and install Docker
  echo "Installing Docker..."
  #!/bin/bash

# Install required packages
sudo yum install -y ca-certificates curl gnupg

# Create keyrings directory
sudo install -m 0755 -d /etc/apt/keyrings

# Add Docker GPG key
curl -fsSL https://download.docker.com/linux/amazon/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add Docker repository to package manager
echo \
  "deb [arch=$(uname -m | sed 's/x86_64/amd64/')] https://download.docker.com/linux/amazon \
  $(rpm -E %amzn_platform_version) stable" | \
  sudo tee /etc/yum.repos.d/docker.list > /dev/null

# Update package manager
sudo yum update -y

# Install Docker packages
sudo yum install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Start and enable Docker service
sudo service docker start
sudo systemctl enable docker

# Adjust Docker socket permissions
sudo chmod 666 /var/run/docker.sock

# Restart Docker service
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
