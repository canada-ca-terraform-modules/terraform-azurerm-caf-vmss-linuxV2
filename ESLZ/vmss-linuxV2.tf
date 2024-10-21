variable "vmss_linuxV2" {
  type        = any
  default     = {}
  description = "Value for vmss_linuxV2. This is a collection of values as defined in vmss-linuxV2.tfvars"
}

module "vmss_linuxV2" {
  for_each = var.vmss_linuxV2
  source   = "github.com/canada-ca-terraform-modules/terraform-azurerm-caf-vmss-linuxV2?ref=v1.0.4"

  location          = var.location
  subnets           = local.subnets
  resource_groups   = local.resource_groups
  userDefinedString = each.key
  env               = var.env
  group             = var.group
  project           = var.project
  tags              = var.tags
  vmss              = each.value
  custom_data       = try(each.value.custom_data, false) != false ? base64encode(file("${path.cwd}/${each.value.custom_data}")) : null
  user_data         = try(each.value.user_data, false) != false ? base64encode(file("${path.cwd}/${each.value.user_data}")) : null
}