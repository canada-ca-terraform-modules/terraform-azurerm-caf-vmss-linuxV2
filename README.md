# AzureRM VMSS Linux V2

## Terraform variables for this module

[./ESLZ/vmss-linuxV2.tfvars](./ESLZ/vmss-linuxV2.tfvars)

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |
| <a name="provider_http"></a> [http](#provider\_http) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_boot_diagnostic_storage"></a> [boot\_diagnostic\_storage](#module\_boot\_diagnostic\_storage) | github.com/canada-ca-terraform-modules/terraform-azurerm-caf-storage_accountV2.git | v1.0.3 |
| <a name="module_load_balancer"></a> [load\_balancer](#module\_load\_balancer) | github.com/canada-ca-terraform-modules/terraform-azurerm-caf-load_balancer.git | v1.0.2 |

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault_secret.vm-admin-password](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_linux_virtual_machine_scale_set.vmss_linux](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine_scale_set) | resource |
| [azurerm_role_assignment.vmss_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_user_assigned_identity.user_assigned_identity_vmss_linux](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [random_password.vm-admin-password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [azurerm_key_vault.key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [http_http.custom_data](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_custom_data"></a> [custom\_data](#input\_custom\_data) | (Optional) The Base64-Encoded Custom Data which should be used for this Virtual Machine Scale Set. | `string` | `null` | no |
| <a name="input_env"></a> [env](#input\_env) | (Required) 4 character string defining the environment name prefix for the VM | `string` | n/a | yes |
| <a name="input_group"></a> [group](#input\_group) | (Required) Character string defining the group for the target subscription | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Azure location for the VM | `string` | `"canadacentral"` | no |
| <a name="input_project"></a> [project](#input\_project) | (Required) Character string defining the project for the target subscription | `string` | n/a | yes |
| <a name="input_resource_groups"></a> [resource\_groups](#input\_resource\_groups) | (Required) Resource group object for the VM | `any` | `{}` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | (Required) List of subnet objects for the VM | `any` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags that will be applied to every associated VM resource | `map(string)` | `{}` | no |
| <a name="input_userDefinedString"></a> [userDefinedString](#input\_userDefinedString) | (Required) User defined portion value for the name of the VM. | `string` | n/a | yes |
| <a name="input_user_data"></a> [user\_data](#input\_user\_data) | (Optional) The Base64-Encoded User Data which should be used for this Virtual Machine Scale Set. | `string` | `null` | no |
| <a name="input_vmss"></a> [vmss](#input\_vmss) | Details about vmss config | `any` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_loaddbalancer"></a> [loaddbalancer](#output\_loaddbalancer) | The availability\_set object |
| <a name="output_vmss_linux"></a> [vmss\_linux](#output\_vmss\_linux) | VMSS Linux object |
<!-- END_TF_DOCS -->