output "vmss_linux" {
  value       = azurerm_linux_virtual_machine_scale_set.vmss_linux
  description = "VMSS Linux object"
}

output "loadbalancer" {
  value       = azurerm_lb.loadbalancer
  description = "Load Balancer object"
}