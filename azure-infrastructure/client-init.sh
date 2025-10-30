#!/bin/bash

# Client VM Initialization Script
echo "Starting Calculator Client VM initialization..."

# Update system
apt-get update -y
apt-get upgrade -y

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
usermod -aG docker azureuser

# Install Docker Compose
curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Install .NET 9.0
wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
dpkg -i packages-microsoft-prod.deb
apt-get update -y
apt-get install -y dotnet-sdk-9.0

# Create application directory
mkdir -p /opt/calculator-client
chown azureuser:azureuser /opt/calculator-client

# Create systemd service for calculator client
cat > /etc/systemd/system/calculator-client.service << EOF
[Unit]
Description=Calculator gRPC Client
After=network.target

[Service]
Type=simple
User=azureuser
WorkingDirectory=/opt/calculator-client
ExecStart=/usr/bin/dotnet Calculator.Client.dll
Restart=always
Environment=ASPNETCORE_ENVIRONMENT=Production
Environment=AZURE_CLIENT_VM_NAME=calculator-client-vm
Environment=AZURE_RESOURCE_GROUP=calculator-grpc-rg
Environment=AZURE_REGION=East US
Environment=AZURE_CLIENT_PRIVATE_IP=10.0.1.5
Environment=AZURE_CLIENT_PUBLIC_DNS=calculator-client.eastus.cloudapp.azure.com
Environment=AZURE_SERVER_PRIVATE_IP=${server_private_ip}
Environment=AZURE_SERVER_PUBLIC_DNS=calculator-server.eastus.cloudapp.azure.com

[Install]
WantedBy=multi-user.target
EOF

# Enable the service
systemctl enable calculator-client.service

# Install monitoring tools
apt-get install -y htop iotop

echo "Calculator Client VM initialization completed!"