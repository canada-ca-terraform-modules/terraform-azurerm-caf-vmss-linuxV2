output "vmss_linux" {
  value       = azurerm_linux_virtual_machine_scale_set.vmss_linux
  sensitive   = true
  description = "VMSS Linux object"
}

output "loaddbalancer" {
  description = "The availability_set object"
  value       = module.load_balancer
}
