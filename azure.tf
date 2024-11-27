resource "azurerm_resource_group" "project_resource_group" {
  name     = "Demo-Project-Resource-Group"
  location = "Central India"
}

resource "azurerm_virtual_network" "project_virtual_network" {
  name                = "Demo-Project-Virtual-Network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.project_resource_group.location
  resource_group_name = azurerm_resource_group.project_resource_group.name

  # Adding timeouts for proper resource state validation
  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }
}

resource "azurerm_subnet" "project_subnet" {
  name                 = "Demo-Project-Subnet"
  resource_group_name  = azurerm_resource_group.project_resource_group.name
  virtual_network_name = azurerm_virtual_network.project_virtual_network.name
  address_prefixes     = ["10.0.1.0/24"]
  
  depends_on = [azurerm_virtual_network.project_virtual_network] # Ensure VNet is created first
}

resource "azurerm_public_ip" "project_public_ip" {
  name                = "Demo-Project-Public-IP"
  location            = azurerm_resource_group.project_resource_group.location
  resource_group_name = azurerm_resource_group.project_resource_group.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "project_network_interface" {
  name                = "Demo-Project-Network-Interface"
  location            = azurerm_resource_group.project_resource_group.location
  resource_group_name = azurerm_resource_group.project_resource_group.name

  ip_configuration {
    name                          = "Internal"
    subnet_id                     = azurerm_subnet.project_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.project_public_ip.id
  }

  depends_on = [
    azurerm_subnet.project_subnet,
    azurerm_public_ip.project_public_ip
  ] # Ensure subnet and public IP are created first
}

resource "azurerm_linux_virtual_machine" "project_virtual_machine" {
  name                  = "Demo-Project-Virtual-Machine"
  location              = azurerm_resource_group.project_resource_group.location
  resource_group_name   = azurerm_resource_group.project_resource_group.name
  network_interface_ids = [azurerm_network_interface.project_network_interface.id]
  size                  = "Standard_B1s"

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name  = "DemoVM"
  admin_username = "azureuser"

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("C:/Users/akush/.ssh/azure_key.pub")
  }

  disable_password_authentication = true

  depends_on = [azurerm_network_interface.project_network_interface] # Ensure NIC is created first
}
