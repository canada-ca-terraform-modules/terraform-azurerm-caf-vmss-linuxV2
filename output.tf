output "vmss_linux" {
  value = azurerm_linux_virtual_machine_scale_set.vmss_linux
}

output "loadbalancer" {
  value = azurerm_lb.loadbalancer
}