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

run "naming_convention" {
  command = plan

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
    error_message = "VMSS name must follow {env4}{SLG}-{userDefinedString}{postfix3}-vmss convention"
  }
}

run "default_values" {
  command = plan

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
    condition     = azurerm_linux_virtual_machine_scale_set.vmss_linux.instances == 0
    error_message = "Default instances must be 0"
  }

  assert {
    condition     = azurerm_linux_virtual_machine_scale_set.vmss_linux.admin_username == "azureadmin"
    error_message = "Default admin_username must be azureadmin"
  }

  assert {
    condition     = azurerm_linux_virtual_machine_scale_set.vmss_linux.resilient_vm_creation_enabled == null
    error_message = "resilient_vm_creation_enabled must default to null"
  }

  assert {
    condition     = azurerm_linux_virtual_machine_scale_set.vmss_linux.resilient_vm_deletion_enabled == null
    error_message = "resilient_vm_deletion_enabled must default to null"
  }
}

run "v5_network_interface_renamed_args" {
  command = plan

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
          # Use new v5 field names
          accelerated_networking_enabled = true
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
    condition     = one(azurerm_linux_virtual_machine_scale_set.vmss_linux.network_interface).accelerated_networking_enabled == true
    error_message = "accelerated_networking_enabled must be true"
  }
}

run "v5_legacy_network_interface_args" {
  command = plan

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
          # Use old v4 field names — must still work
          enable_accelerated_networking = true
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
    condition     = one(azurerm_linux_virtual_machine_scale_set.vmss_linux.network_interface).accelerated_networking_enabled == true
    error_message = "Old v4 enable_accelerated_networking must map to v5 accelerated_networking_enabled"
  }
}

run "v5_resilient_args" {
  command = plan

  variables {
    vmss = {
      postfix                         = "001"
      resource_group_name             = "MyRG"
      sku                             = "Standard_D2s_v3"
      resilient_vm_creation_enabled   = true
      resilient_vm_deletion_enabled   = true
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
    condition     = azurerm_linux_virtual_machine_scale_set.vmss_linux.resilient_vm_creation_enabled == true
    error_message = "resilient_vm_creation_enabled must be true"
  }

  assert {
    condition     = azurerm_linux_virtual_machine_scale_set.vmss_linux.resilient_vm_deletion_enabled == true
    error_message = "resilient_vm_deletion_enabled must be true"
  }
}
