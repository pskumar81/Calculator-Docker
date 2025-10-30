# Configure the Azure Provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

# Variables
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "calculator-grpc-rg"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "East US"
}

variable "admin_username" {
  description = "Admin username for VMs"
  type        = string
  default     = "azureuser"
}

variable "admin_password" {
  description = "Admin password for VMs"
  type        = string
  sensitive   = true
}

variable "vm_size" {
  description = "Size of the VMs"
  type        = string
  default     = "Standard_B2s"
}

# Resource Group
resource "azurerm_resource_group" "calculator_rg" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    Environment = "Production"
    Project     = "Calculator-gRPC"
  }
}

# Virtual Network
resource "azurerm_virtual_network" "calculator_vnet" {
  name                = "calculator-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.calculator_rg.location
  resource_group_name = azurerm_resource_group.calculator_rg.name

  tags = {
    Environment = "Production"
    Project     = "Calculator-gRPC"
  }
}

# Subnet
resource "azurerm_subnet" "calculator_subnet" {
  name                 = "calculator-subnet"
  resource_group_name  = azurerm_resource_group.calculator_rg.name
  virtual_network_name = azurerm_virtual_network.calculator_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Network Security Group
resource "azurerm_network_security_group" "calculator_nsg" {
  name                = "calculator-nsg"
  location            = azurerm_resource_group.calculator_rg.location
  resource_group_name = azurerm_resource_group.calculator_rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "RDP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "gRPC"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5002"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTP"
    priority                   = 1004
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    Environment = "Production"
    Project     = "Calculator-gRPC"
  }
}

# Associate Network Security Group to Subnet
resource "azurerm_subnet_network_security_group_association" "calculator_nsg_association" {
  subnet_id                 = azurerm_subnet.calculator_subnet.id
  network_security_group_id = azurerm_network_security_group.calculator_nsg.id
}

# Public IP for Server
resource "azurerm_public_ip" "server_public_ip" {
  name                = "calculator-server-pip"
  resource_group_name = azurerm_resource_group.calculator_rg.name
  location            = azurerm_resource_group.calculator_rg.location
  allocation_method   = "Static"
  domain_name_label   = "calculator-server"

  tags = {
    Environment = "Production"
    Project     = "Calculator-gRPC"
    Role        = "Server"
  }
}

# Public IP for Client
resource "azurerm_public_ip" "client_public_ip" {
  name                = "calculator-client-pip"
  resource_group_name = azurerm_resource_group.calculator_rg.name
  location            = azurerm_resource_group.calculator_rg.location
  allocation_method   = "Static"
  domain_name_label   = "calculator-client"

  tags = {
    Environment = "Production"
    Project     = "Calculator-gRPC"
    Role        = "Client"
  }
}

# Network Interface for Server
resource "azurerm_network_interface" "server_nic" {
  name                = "calculator-server-nic"
  location            = azurerm_resource_group.calculator_rg.location
  resource_group_name = azurerm_resource_group.calculator_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.calculator_subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.1.4"
    public_ip_address_id          = azurerm_public_ip.server_public_ip.id
  }

  tags = {
    Environment = "Production"
    Project     = "Calculator-gRPC"
    Role        = "Server"
  }
}

# Network Interface for Client
resource "azurerm_network_interface" "client_nic" {
  name                = "calculator-client-nic"
  location            = azurerm_resource_group.calculator_rg.location
  resource_group_name = azurerm_resource_group.calculator_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.calculator_subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.1.5"
    public_ip_address_id          = azurerm_public_ip.client_public_ip.id
  }

  tags = {
    Environment = "Production"
    Project     = "Calculator-gRPC"
    Role        = "Client"
  }
}

# Virtual Machine for Server
resource "azurerm_linux_virtual_machine" "server_vm" {
  name                = "calculator-server-vm"
  resource_group_name = azurerm_resource_group.calculator_rg.name
  location            = azurerm_resource_group.calculator_rg.location
  size                = var.vm_size
  admin_username      = var.admin_username

  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.server_nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  admin_password = var.admin_password

  custom_data = base64encode(templatefile("${path.module}/server-init.sh", {
    server_private_ip = "10.0.1.4"
  }))

  tags = {
    Environment = "Production"
    Project     = "Calculator-gRPC"
    Role        = "Server"
  }
}

# Virtual Machine for Client
resource "azurerm_linux_virtual_machine" "client_vm" {
  name                = "calculator-client-vm"
  resource_group_name = azurerm_resource_group.calculator_rg.name
  location            = azurerm_resource_group.calculator_rg.location
  size                = var.vm_size
  admin_username      = var.admin_username

  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.client_nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  admin_password = var.admin_password

  custom_data = base64encode(templatefile("${path.module}/client-init.sh", {
    server_private_ip = "10.0.1.4"
  }))

  tags = {
    Environment = "Production"
    Project     = "Calculator-gRPC"
    Role        = "Client"
  }
}

# Outputs
output "server_public_ip" {
  value = azurerm_public_ip.server_public_ip.ip_address
}

output "client_public_ip" {
  value = azurerm_public_ip.client_public_ip.ip_address
}

output "server_fqdn" {
  value = azurerm_public_ip.server_public_ip.fqdn
}

output "client_fqdn" {
  value = azurerm_public_ip.client_public_ip.fqdn
}

output "server_private_ip" {
  value = azurerm_network_interface.server_nic.private_ip_address
}

output "client_private_ip" {
  value = azurerm_network_interface.client_nic.private_ip_address
}