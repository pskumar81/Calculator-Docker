# PowerShell script for Azure VM deployment
param(
    [Parameter(Mandatory=$false)]
    [string]$SubscriptionId = "",
    
    [Parameter(Mandatory=$false)]
    [string]$ResourceGroupName = "calculator-grpc-rg",
    
    [Parameter(Mandatory=$false)]
    [string]$Location = "East US",
    
    [Parameter(Mandatory=$false)]
    [string]$AdminUsername = "azureuser",
    
    [Parameter(Mandatory=$true)]
    [SecureString]$AdminPassword
)

# Configuration
$ServerVmName = "calculator-server-vm"
$ClientVmName = "calculator-client-vm"

Write-Host "========================================" -ForegroundColor Green
Write-Host "Calculator gRPC Azure VM Deployment" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green

# Check if Azure PowerShell is installed
try {
    Import-Module Az -ErrorAction Stop
} catch {
    Write-Host "Azure PowerShell module is not installed. Please install it first." -ForegroundColor Red
    Write-Host "Install-Module -Name Az -AllowClobber -Scope CurrentUser" -ForegroundColor Yellow
    exit 1
}

# Connect to Azure
Write-Host "Connecting to Azure..." -ForegroundColor Yellow
Connect-AzAccount

# Set subscription if provided
if ($SubscriptionId) {
    Write-Host "Setting subscription: $SubscriptionId" -ForegroundColor Yellow
    Set-AzContext -SubscriptionId $SubscriptionId
}

# Create resource group
Write-Host "Creating resource group: $ResourceGroupName" -ForegroundColor Yellow
New-AzResourceGroup -Name $ResourceGroupName -Location $Location -Force

# Convert SecureString to plain text for ARM template
$PlainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($AdminPassword))

# Deploy infrastructure using ARM template
Write-Host "Deploying Azure infrastructure..." -ForegroundColor Yellow
$deployment = New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -TemplateFile "..\azure-infrastructure\calculator-vms.json" `
    -adminUsername $AdminUsername `
    -adminPassword $PlainPassword `
    -serverVmName $ServerVmName `
    -clientVmName $ClientVmName

if ($deployment.ProvisioningState -eq "Succeeded") {
    Write-Host "Infrastructure deployment completed successfully!" -ForegroundColor Green
} else {
    Write-Host "Infrastructure deployment failed!" -ForegroundColor Red
    exit 1
}

# Get VM information
Write-Host "Getting VM information..." -ForegroundColor Yellow
$serverVm = Get-AzVM -ResourceGroupName $ResourceGroupName -Name $ServerVmName
$clientVm = Get-AzVM -ResourceGroupName $ResourceGroupName -Name $ClientVmName

$serverPublicIp = (Get-AzPublicIpAddress -ResourceGroupName $ResourceGroupName -Name "calculator-server-pip").IpAddress
$clientPublicIp = (Get-AzPublicIpAddress -ResourceGroupName $ResourceGroupName -Name "calculator-client-pip").IpAddress

Write-Host "Server VM Public IP: $serverPublicIp" -ForegroundColor Green
Write-Host "Client VM Public IP: $clientPublicIp" -ForegroundColor Green

# Build applications
Write-Host "Building applications..." -ForegroundColor Yellow
Set-Location ".."
dotnet build -c Release
dotnet publish Calculator.Server -c Release -o ".\publish\server"
dotnet publish Calculator.Client -c Release -o ".\publish\client"

Write-Host "========================================" -ForegroundColor Green
Write-Host "Deployment preparation completed!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Copy files to VMs using SCP/WinSCP" -ForegroundColor White
Write-Host "2. SSH into VMs and start services:" -ForegroundColor White
Write-Host "   Server: ssh $AdminUsername@$serverPublicIp" -ForegroundColor White
Write-Host "   Client: ssh $AdminUsername@$clientPublicIp" -ForegroundColor White
Write-Host "3. Start services:" -ForegroundColor White
Write-Host "   sudo systemctl start calculator-server" -ForegroundColor White
Write-Host "   sudo systemctl start calculator-client" -ForegroundColor White
Write-Host "========================================" -ForegroundColor Green