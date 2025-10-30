# Azure VM Deployment Guide

This guide explains how to deploy the Calculator gRPC solution to separate Azure VMs for client and server components.

## Architecture Overview

```
┌─────────────────┐    ┌─────────────────┐
│   Client VM     │    │   Server VM     │
│  (10.0.1.5)     │    │  (10.0.1.4)     │
│                 │    │                 │
│ Calculator      │────│ Calculator      │
│ Client          │gRPC│ Server          │
│                 │5002│                 │
└─────────────────┘    └─────────────────┘
         │                       │
         └───────────────────────┘
              Azure VNet
            (10.0.0.0/16)
```

## Prerequisites

- Azure CLI or Azure PowerShell
- .NET 9.0 SDK
- SSH client for Linux VMs
- Valid Azure subscription

## Deployment Options

### Option 1: Using ARM Templates

1. **Set parameters in `calculator-vms.parameters.json`:**
   ```json
   {
     "adminUsername": { "value": "your-username" },
     "adminPassword": { "value": "your-secure-password" }
   }
   ```

2. **Deploy using Azure CLI:**
   ```bash
   az group create --name calculator-grpc-rg --location "East US"
   az deployment group create \
     --resource-group calculator-grpc-rg \
     --template-file azure-infrastructure/calculator-vms.json \
     --parameters azure-infrastructure/calculator-vms.parameters.json
   ```

### Option 2: Using Terraform

1. **Initialize Terraform:**
   ```bash
   cd azure-infrastructure
   terraform init
   ```

2. **Set variables:**
   ```bash
   export TF_VAR_admin_password="your-secure-password"
   ```

3. **Deploy:**
   ```bash
   terraform plan
   terraform apply
   ```

### Option 3: Using Deployment Scripts

#### Bash Script (Linux/WSL)
```bash
chmod +x deployment-scripts/deploy-azure.sh
./deployment-scripts/deploy-azure.sh
```

#### PowerShell Script (Windows)
```powershell
$securePassword = ConvertTo-SecureString "YourPassword123!" -AsPlainText -Force
.\deployment-scripts\Deploy-Azure.ps1 -AdminPassword $securePassword
```

## Infrastructure Components

### Virtual Network
- **Name:** calculator-vnet
- **Address Space:** 10.0.0.0/16
- **Subnet:** calculator-subnet (10.0.1.0/24)

### Network Security Group
- **SSH (22):** Allow from anywhere
- **RDP (3389):** Allow from anywhere
- **gRPC (5002):** Allow from VNet only
- **HTTP (80):** Allow from anywhere

### Virtual Machines
- **Server VM:** calculator-server-vm (10.0.1.4)
- **Client VM:** calculator-client-vm (10.0.1.5)
- **OS:** Ubuntu 20.04 LTS
- **Size:** Standard_B2s (default)

## Configuration Files

### Server Configuration (`appsettings.Production.json`)
```json
{
  "Kestrel": {
    "Endpoints": {
      "Http": {
        "Url": "http://0.0.0.0:5002"
      }
    }
  },
  "Azure": {
    "VM": {
      "Name": "${AZURE_VM_NAME}",
      "PrivateIP": "${AZURE_PRIVATE_IP}",
      "PublicDNS": "${AZURE_PUBLIC_DNS}"
    }
  }
}
```

### Client Configuration (`appsettings.Production.json`)
```json
{
  "CalculatorService": {
    "ServerUrl": "http://${AZURE_SERVER_PRIVATE_IP}:5002"
  },
  "Azure": {
    "Server": {
      "PrivateIP": "${AZURE_SERVER_PRIVATE_IP}",
      "Port": 5002
    }
  }
}
```

## Environment Variables

The following environment variables are set during VM initialization:

### Server VM
- `AZURE_VM_NAME`: calculator-server-vm
- `AZURE_RESOURCE_GROUP`: calculator-grpc-rg
- `AZURE_REGION`: East US
- `AZURE_PRIVATE_IP`: 10.0.1.4
- `AZURE_PUBLIC_DNS`: calculator-server.eastus.cloudapp.azure.com

### Client VM
- `AZURE_CLIENT_VM_NAME`: calculator-client-vm
- `AZURE_SERVER_PRIVATE_IP`: 10.0.1.4
- `AZURE_SERVER_PUBLIC_DNS`: calculator-server.eastus.cloudapp.azure.com

## Manual Deployment Steps

If using the automated scripts, these steps are handled automatically. For manual deployment:

### 1. Build Applications
```bash
dotnet build -c Release
dotnet publish Calculator.Server -c Release -o ./publish/server
dotnet publish Calculator.Client -c Release -o ./publish/client
```

### 2. Copy Files to VMs
```bash
# Server
scp -r ./publish/server/* azureuser@<server-public-ip>:/opt/calculator-server/

# Client
scp -r ./publish/client/* azureuser@<client-public-ip>:/opt/calculator-client/
```

### 3. Start Services
```bash
# On Server VM
sudo systemctl start calculator-server
sudo systemctl enable calculator-server

# On Client VM
sudo systemctl start calculator-client
sudo systemctl enable calculator-client
```

## Health Checks

The server exposes health check endpoints:
- `http://<server-ip>:5002/health` - General health
- `http://<server-ip>:5002/health/ready` - Readiness probe
- `http://<server-ip>:5002/health/live` - Liveness probe

## Monitoring

### Application Insights
Configure Application Insights by setting the instrumentation key:
```bash
export APPINSIGHTS_INSTRUMENTATIONKEY="your-instrumentation-key"
```

### Logs
Application logs are available:
- Server: `/opt/calculator-server/logs/`
- Client: `/opt/calculator-client/logs/`
- System logs: `journalctl -u calculator-server` or `journalctl -u calculator-client`

## Security Considerations

1. **Network Security:**
   - gRPC port (5002) only accessible within VNet
   - Use private IPs for inter-VM communication

2. **VM Security:**
   - Regular security updates
   - Key-based SSH authentication (recommended)
   - Azure Security Center monitoring

3. **Application Security:**
   - Non-root user execution in containers
   - Secure configuration management

## Troubleshooting

### Common Issues

1. **Connection Refused:**
   ```bash
   # Check if service is running
   sudo systemctl status calculator-server
   
   # Check logs
   journalctl -u calculator-server -f
   ```

2. **Port Issues:**
   ```bash
   # Check if port is listening
   netstat -tlnp | grep 5002
   
   # Test connectivity
   telnet <server-private-ip> 5002
   ```

3. **DNS Resolution:**
   ```bash
   # Test DNS
   nslookup calculator-server.eastus.cloudapp.azure.com
   ```

## Cost Optimization

- Use **Azure Reserved Instances** for long-term deployments
- Consider **Azure Spot VMs** for development environments
- Implement **auto-shutdown** for non-production VMs
- Use **Azure Monitor** to track resource usage

## Scaling

For production workloads, consider:
- **Azure Load Balancer** for multiple server instances
- **Azure Application Gateway** for advanced load balancing
- **Azure Virtual Machine Scale Sets** for auto-scaling
- **Azure Container Instances** or **Azure Kubernetes Service** for containerized deployments

## Cleanup

To remove all resources:
```bash
az group delete --name calculator-grpc-rg --yes --no-wait
```

Or with Terraform:
```bash
terraform destroy
```