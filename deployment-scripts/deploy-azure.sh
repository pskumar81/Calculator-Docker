#!/bin/bash

# Azure VM Deployment Script for Calculator gRPC
# This script deploys the Calculator gRPC solution to Azure VMs

set -e

# Configuration
RESOURCE_GROUP="calculator-grpc-rg"
LOCATION="East US"
SUBSCRIPTION_ID=""
SERVER_VM_NAME="calculator-server-vm"
CLIENT_VM_NAME="calculator-client-vm"
ADMIN_USERNAME="azureuser"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Calculator gRPC Azure VM Deployment${NC}"
echo -e "${GREEN}========================================${NC}"

# Check if Azure CLI is installed
if ! command -v az &> /dev/null; then
    echo -e "${RED}Azure CLI is not installed. Please install it first.${NC}"
    exit 1
fi

# Login to Azure
echo -e "${YELLOW}Logging into Azure...${NC}"
az login

# Set subscription if provided
if [ ! -z "$SUBSCRIPTION_ID" ]; then
    echo -e "${YELLOW}Setting subscription: $SUBSCRIPTION_ID${NC}"
    az account set --subscription "$SUBSCRIPTION_ID"
fi

# Create resource group
echo -e "${YELLOW}Creating resource group: $RESOURCE_GROUP${NC}"
az group create --name "$RESOURCE_GROUP" --location "$LOCATION"

# Deploy infrastructure using ARM template
echo -e "${YELLOW}Deploying Azure infrastructure...${NC}"
az deployment group create \
    --resource-group "$RESOURCE_GROUP" \
    --template-file "../azure-infrastructure/calculator-vms.json" \
    --parameters "../azure-infrastructure/calculator-vms.parameters.json" \
    --parameters adminPassword="$(openssl rand -base64 32)"

# Get VM IP addresses
echo -e "${YELLOW}Getting VM information...${NC}"
SERVER_PUBLIC_IP=$(az vm show -d -g "$RESOURCE_GROUP" -n "$SERVER_VM_NAME" --query publicIps -o tsv)
CLIENT_PUBLIC_IP=$(az vm show -d -g "$RESOURCE_GROUP" -n "$CLIENT_VM_NAME" --query publicIps -o tsv)
SERVER_PRIVATE_IP=$(az vm show -d -g "$RESOURCE_GROUP" -n "$SERVER_VM_NAME" --query privateIps -o tsv)
CLIENT_PRIVATE_IP=$(az vm show -d -g "$RESOURCE_GROUP" -n "$CLIENT_VM_NAME" --query privateIps -o tsv)

echo -e "${GREEN}Server VM Public IP: $SERVER_PUBLIC_IP${NC}"
echo -e "${GREEN}Server VM Private IP: $SERVER_PRIVATE_IP${NC}"
echo -e "${GREEN}Client VM Public IP: $CLIENT_PUBLIC_IP${NC}"
echo -e "${GREEN}Client VM Private IP: $CLIENT_PRIVATE_IP${NC}"

# Wait for VMs to be ready
echo -e "${YELLOW}Waiting for VMs to be ready...${NC}"
sleep 60

# Build and publish applications
echo -e "${YELLOW}Building applications...${NC}"
cd ..
dotnet build -c Release
dotnet publish Calculator.Server -c Release -o ./publish/server
dotnet publish Calculator.Client -c Release -o ./publish/client

# Copy server files to server VM
echo -e "${YELLOW}Deploying server application...${NC}"
scp -o StrictHostKeyChecking=no -r ./publish/server/* $ADMIN_USERNAME@$SERVER_PUBLIC_IP:/opt/calculator-server/

# Copy client files to client VM
echo -e "${YELLOW}Deploying client application...${NC}"
scp -o StrictHostKeyChecking=no -r ./publish/client/* $ADMIN_USERNAME@$CLIENT_PUBLIC_IP:/opt/calculator-client/

# Start server service
echo -e "${YELLOW}Starting server service...${NC}"
ssh -o StrictHostKeyChecking=no $ADMIN_USERNAME@$SERVER_PUBLIC_IP "sudo systemctl start calculator-server && sudo systemctl enable calculator-server"

# Start client service
echo -e "${YELLOW}Starting client service...${NC}"
ssh -o StrictHostKeyChecking=no $ADMIN_USERNAME@$CLIENT_PUBLIC_IP "sudo systemctl start calculator-client && sudo systemctl enable calculator-client"

# Verify deployment
echo -e "${YELLOW}Verifying deployment...${NC}"
if curl -f http://$SERVER_PUBLIC_IP:5002/health; then
    echo -e "${GREEN}✓ Server health check passed${NC}"
else
    echo -e "${RED}✗ Server health check failed${NC}"
fi

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Deployment completed successfully!${NC}"
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Server URL: http://$SERVER_PUBLIC_IP:5002${NC}"
echo -e "${GREEN}Client VM: ssh $ADMIN_USERNAME@$CLIENT_PUBLIC_IP${NC}"
echo -e "${GREEN}Server VM: ssh $ADMIN_USERNAME@$SERVER_PUBLIC_IP${NC}"
echo -e "${GREEN}========================================${NC}"