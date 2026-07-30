module "load_balancer" {
  count  = try(var.vmss.lb, null) != null ? 1 : 0
  source = "github.com/canada-ca-terraform-modules/terraform-azurerm-caf-load_balancer.git?ref=v2.0.0"

  location          = var.location
  subnets           = var.subnets
  resource_groups   = var.resource_groups
  userDefinedString = var.userDefinedString
  tags              = var.tags
  env               = var.env
  load_balancer     = merge(var.vmss.lb, { postfix = var.vmss.postfix, resource_group_name = var.vmss.resource_group_name, custom_name = local.vmss_name })
}

# Preserve state for existing deployments created before the load balancer
# resources were refactored into the terraform-azurerm-caf-load_balancer
# submodule call above. Without these, every LB resource is destroyed under
# its old flat address and recreated under the module address.
moved {
  from = azurerm_lb.loadbalancer[0]
  to   = module.load_balancer[0].azurerm_lb.loadbalancer
}

moved {
  from = azurerm_lb_backend_address_pool.loadbalancer-lbbp[0]
  to   = module.load_balancer[0].azurerm_lb_backend_address_pool.loadbalancer-lbbp
}

moved {
  from = azurerm_lb_probe.loadbalancer-lbhp
  to   = module.load_balancer[0].azurerm_lb_probe.loadbalancer-lbhp
}

moved {
  from = azurerm_lb_rule.loadbalancer-lbr
  to   = module.load_balancer[0].azurerm_lb_rule.loadbalancer-lbr
}

