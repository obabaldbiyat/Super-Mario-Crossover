terraform {
   required_version = ">= 0.12"
   required_providers {
      azurerm = ">3.0"
   }
}

provider "azurerm" {
   subscription_id = var.subscription_id
   #client_id = var.client_id
   #client_secret = var.client_secret
   tenant_id = var.tenant_id
   skip_provider_registration = true
   features {}
}

########Variables######################
variable "Resource_Group_name" {
    type = string
    default = "ObabMarioJenkins"
    description = "Name of the resource group"
}

variable "location" {
  type = string
  default = "westeurope"
  description = "The location for the deployement"
}

#######################

variable "subscription_id" {
   description = "Azure subscription"
   default = "393e3de3-0900-4b72-8f1b-fb3b1d6b97f1"
}

#variable "client_id" {
#   description = "Azure Client ID"
#   default = "384ba4e4-fc1a-47f4-bf42-acec6fad1e82"
#}

#variable "client_secret" {
#   description = "Azure Client Secret"
#   default = "lxk8Q~LfBuObGY4frVfc6B_e4Nqf6UMahS-BdaD-"
#}

variable "tenant_id" {
   description = "Azure Tenant ID"
   default = "7349d3b2-951f-41be-877e-d8ccd9f3e73c"
}

variable "instance_size" {
   type = string
   description = "Azure instance size"
   default = "Standard_F2"
}

#variable "location" {
#   type = string
#   description = "Region"
#   default = "France Central"
#}

variable "environment" {
   type = string
   description = "Environment"
   default = "Prod"
}

########################

resource "azurerm_virtual_network" "obabwebserver-net" {
  name                = "obabwebserver-net"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.obabwebserver.name
}

resource "azurerm_subnet" "obabwebserver-subnet" {
  name                 = "subnet01"
  resource_group_name  = azurerm_resource_group.obabwebserver.name
  virtual_network_name = azurerm_virtual_network.obabwebserver-net.name
  address_prefixes       = ["10.0.1.0/24"]

  private_link_service_network_policies_enabled = false
}

#############################""

resource "azurerm_resource_group" "obabwebserver" {
  name = "${var.Resource_Group_name}"
  location = "${var.location}"
}

###########################

#resource "azurerm_resource_group" "obabwebserver" {
#   name = "obabserver"
#   location = var.location
#}

resource "azurerm_network_security_group" "allowedports" {
   name = "allowedports"
   resource_group_name = azurerm_resource_group.obabwebserver.name
   location = var.location
  
   security_rule {
       name = "http"
       priority = 100
       direction = "Inbound"
       access = "Allow"
       protocol = "Tcp"
       source_port_range = "*"
       destination_port_range = "80"
       source_address_prefix = "*"
       destination_address_prefix = "*"
   }

   security_rule {
       name = "https"
       priority = 200
       direction = "Inbound"
       access = "Allow"
       protocol = "Tcp"
       source_port_range = "*"
       destination_port_range = "443"
       source_address_prefix = "*"
       destination_address_prefix = "*"
   }

   security_rule {
       name = "ssh"
       priority = 300
       direction = "Inbound"
       access = "Allow"
       protocol = "Tcp"
       source_port_range = "*"
       destination_port_range = "22"
       source_address_prefix = "*"
       destination_address_prefix = "*"
   }
  
   security_rule {
       name = "Custom"
       priority = 350
       direction = "Inbound"
       access = "Allow"
       protocol = "Tcp"
       source_port_range = "*"
       destination_port_range = "9999"
       source_address_prefix = "*"
       destination_address_prefix = "*"
   }
   
}

resource "azurerm_public_ip" "obabwebserver_public_ip" {
   name = "obabwebserver_public_ip"
   location = var.location
   resource_group_name = azurerm_resource_group.obabwebserver.name
   allocation_method = "Dynamic"

   tags = {
       environment = var.environment
       costcenter = "it"
   }

   depends_on = [azurerm_resource_group.obabwebserver]
}

resource "azurerm_network_interface" "obabwebserver" {
   name = "interface"
   location = var.location
   resource_group_name = azurerm_resource_group.obabwebserver.name

   ip_configuration {
       name = "internal"
       private_ip_address_allocation = "Dynamic"
       subnet_id = azurerm_subnet.obabwebserver-subnet.id
       public_ip_address_id = azurerm_public_ip.obabwebserver_public_ip.id
   }

   depends_on = [azurerm_resource_group.obabwebserver]
}

resource "azurerm_linux_virtual_machine" "obab" {
   size = var.instance_size
   name = "obabwebserver"
   resource_group_name = azurerm_resource_group.obabwebserver.name
   location = var.location
   custom_data = base64encode(file("init-script.sh"))
   network_interface_ids = [
       azurerm_network_interface.obabwebserver.id,
   ]

   source_image_reference {
       publisher = "Canonical"
       offer = "UbuntuServer"
       sku = "18.04-LTS"
       version = "latest"
   }

   computer_name = "obabmario"
   admin_username = "obabadmin"
   admin_password = "Azertyuiop1234"
   disable_password_authentication = false

   os_disk {
       name = "disk01"
       caching = "ReadWrite"
       #create_option = "FromImage"
       storage_account_type = "Standard_LRS"
   }

   tags = {
       environment = var.environment
       costcenter = "it"
   }

   depends_on = [azurerm_resource_group.obabwebserver]
}


##############outputs#########
output "resource_group_name" {
  value = azurerm_resource_group.obabwebserver.name
}

output "The_subnet_ID" {
 value = azurerm_subnet.obabwebserver-subnet.id
}

output "The_vnet_ID" {
 value = azurerm_virtual_network.obabwebserver-net.id
}

output "The_websrever_Private_ip" {
   value = azurerm_linux_virtual_machine.obab.private_ip_address
}

output "The_obabwebserver_Public_ip" {
   value = azurerm_linux_virtual_machine.obab.public_ip_address
}
