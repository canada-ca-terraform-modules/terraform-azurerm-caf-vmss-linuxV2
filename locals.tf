locals {
  # If resource_group was an ID, then parse the ID for the name, if not, then search in the provided resource_groups object
  resource_group_name = strcontains(var.vmss.resource_group_name, "/resourceGroups/") ? regex("[^\\/]+$", var.vmss.resource_group_name) : var.resource_groups[var.vmss.resource_group_name].name

  # If disable_password_authentication is set to true, then no password is set. In this case, a ssh key is required. 
  vm-admin-password = try(var.vmss.disable_password_authentication, false) ? null : (try(var.vmss.admin_password, "") == "" ? random_password.vm-admin-password[0].result : var.vmss.admin_password)

  # This list is used to organize the nics given to the module, used to determine which NIC will be the primary one. (At index 0)
  nic_indices = { for k, v in var.vmss.nic : k => index(keys(var.vmss.nic), k) }
}