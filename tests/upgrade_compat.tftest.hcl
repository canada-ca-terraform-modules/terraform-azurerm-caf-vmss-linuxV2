mock_provider "azurerm" {}
mock_provider "http" {}
mock_provider "random" {}

variables {
  env               = "DevA"
  group             = "Test"
  project           = "Proj"
  userDefinedString = "myapp"
  location          = "canadacentral"
  tags              = {}
  resource_groups = {
    "MyRG"     = { name = "DevA-Test-Proj-MyRG-rg", id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/DevA-Test-Proj-MyRG-rg" }
    "Keyvault" = { name = "DevA-Test-Proj-Keyvault-rg", id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/DevA-Test-Proj-Keyvault-rg" }
  }
  subnets = {
    "subnet1" = { id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/net-rg/providers/Microsoft.Network/virtualNetworks/vnet/subnets/subnet1" }
  }
}

# Step 1: simulate currently-deployed resource with pre-upgrade (v4) field names
run "baseline_apply" {
  command = apply

  variables {
    vmss = {
      postfix                         = "001"
      resource_group_name             = "MyRG"
      sku                             = "Standard_D2s_v3"
      disable_password_authentication = true
      admin_ssh_key = {
        public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQChRHWCNe+3se23b97P4jWTN7uNyljjgz3+RP2DJPV7BTr3CseKtk9tS10mkAPhMckTlSpUsehbwcBdbJh1+3iWTiE0Kn94PQG/QQDfkBgR24Y1wVhmd1qlR1kwWVFWVAzv53xWHG3QzzkfMDjJw6Su3mreJK8EQaw6Ou82B4k60A/be06lqxfHHwaHd6j8vSJRxetLHn9xmTlUnLtfQWQWvIz5Yh1akHGeMFx9rHiA+229zpeO5UwmwRDVUll389weCMlLJVVwqN9v9QA7AWchZ54M1OaDuwQ26GkFme5ozI/qkps0F7W2iee/zorChmYp9zKs7BtGD7tJx8o39o0r test@test"
        username   = "azureadmin"
      }
      source_image_reference = {
        publisher = "Canonical"
        offer     = "0001-com-ubuntu-server-jammy"
        sku       = "22_04-lts"
        version   = "latest"
      }
      os_disk = {
        caching              = "ReadWrite"
        storage_account_type = "Standard_LRS"
      }
      nic = {
        nic1 = {
          # v4 field names
          enable_accelerated_networking = false
          enable_ip_forwarding          = false
          ip_configuration = {
            ipc1 = {
              subnet = "subnet1"
            }
          }
        }
      }
    }
  }

  assert {
    condition     = azurerm_linux_virtual_machine_scale_set.vmss_linux.name == "DevASLG-myapp001-vmss"
    error_message = "Baseline apply: unexpected resource name"
  }
}

# Step 2: plan upgraded config (v5 new args) against baseline state — must produce no replacement
run "upgrade_plan_no_replacement" {
  command = plan

  variables {
    vmss = {
      postfix                         = "001"
      resource_group_name             = "MyRG"
      sku                             = "Standard_D2s_v3"
      resilient_vm_creation_enabled   = false
      resilient_vm_deletion_enabled   = false
      disable_password_authentication = true
      admin_ssh_key = {
        public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQChRHWCNe+3se23b97P4jWTN7uNyljjgz3+RP2DJPV7BTr3CseKtk9tS10mkAPhMckTlSpUsehbwcBdbJh1+3iWTiE0Kn94PQG/QQDfkBgR24Y1wVhmd1qlR1kwWVFWVAzv53xWHG3QzzkfMDjJw6Su3mreJK8EQaw6Ou82B4k60A/be06lqxfHHwaHd6j8vSJRxetLHn9xmTlUnLtfQWQWvIz5Yh1akHGeMFx9rHiA+229zpeO5UwmwRDVUll389weCMlLJVVwqN9v9QA7AWchZ54M1OaDuwQ26GkFme5ozI/qkps0F7W2iee/zorChmYp9zKs7BtGD7tJx8o39o0r test@test"
        username   = "azureadmin"
      }
      source_image_reference = {
        publisher = "Canonical"
        offer     = "0001-com-ubuntu-server-jammy"
        sku       = "22_04-lts"
        version   = "latest"
      }
      os_disk = {
        caching              = "ReadWrite"
        storage_account_type = "Standard_LRS"
      }
      nic = {
        nic1 = {
          # v5 new field names
          accelerated_networking_enabled = false
          ip_forwarding_enabled          = false
          ip_configuration = {
            ipc1 = {
              subnet = "subnet1"
            }
          }
        }
      }
    }
  }

  assert {
    condition     = azurerm_linux_virtual_machine_scale_set.vmss_linux.name == "DevASLG-myapp001-vmss"
    error_message = "Upgrade plan: resource name must not change"
  }
}
