output "vmss_linux" {
  value       = azurerm_linux_virtual_machine_scale_set.vmss_linux
  description = "VMSS Linux object"
}

output "loaddbalancer" {
  description = "The availability_set object"
  value       = module.load_balancer
}