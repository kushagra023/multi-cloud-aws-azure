output "aws_internet_public_ip" {
  value       = aws_instance.project_instance.public_ip
  description = "Public IP address of the AWS EC2 instance."
}

output "aws_instance_private_ip" {
  value       = aws_instance.project_instance.private_ip
  description = "Private IP address of the AWS EC2 instance."
}

output "azure_public_ip_address" {
  value       = azurerm_public_ip.project_public_ip.ip_address
  description = "Public IP address of the Azure virtual machine."
}

output "azure_private_ip_address" {
  value       = azurerm_network_interface.project_network_interface.private_ip_address
  description = "Private IP address of the Azure virtual machine."
}
