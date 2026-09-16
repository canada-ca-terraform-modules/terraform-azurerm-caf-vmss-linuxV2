# Changelog

All notable changes to this module will be documented in this file.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [Unreleased]

### Added

- `custom_data` now also accepts an arbitrary `http://`/`https://` URL, fetched and base64-encoded the same way as the existing `install-ca-certs` keyword (previously only that hard-coded keyword or a base64-encoded value/local file path were supported).
- `custom_data` accepts a new `"cloud-init-default"` keyword, resolving to a G3/non-G3-specific `cloud-init-default.yaml` public blob based on `var.env`.

### Changed

- `install-ca-certs` is now a deprecated alias of `cloud-init-default`: it resolves to the same `cloud-init-default.yaml`, which installs the CA certs and also runs the original `linux-ubuntu-customdata-default.sh` script via `runcmd` (previously `install-ca-certs` fetched that `.sh` script directly).
- `ESLZ/vmss-linuxV2.tfvars` example now defaults `custom_data` to `"cloud-init-default"` instead of `"install-ca-certs"`.

## [1.1.1] - 2026-07-30

### Fixed

- **State-breaking:** Added `moved` blocks for `azurerm_lb.loadbalancer`, `azurerm_lb_backend_address_pool.loadbalancer-lbbp`, `azurerm_lb_probe.loadbalancer-lbhp`, and `azurerm_lb_rule.loadbalancer-lbr` so existing deployments migrate state into the `module.load_balancer` submodule call instead of being destroyed and recreated. This gap predates the azurerm v5 upgrade but was only surfaced by an upgrade probe on this branch.
- **Security regression:** Reverted `encryption_at_host_enabled` default from `false` back to `true`. The `false` default (introduced in v1.0.6) silently disabled host encryption for any caller not explicitly setting this field. Callers relying on the `false` default must now set `vmss.encryption_at_host_enabled = false` explicitly.

## [1.1.0] - 2026-07-29


### Changed

- **BREAKING (handled via compat fallback):** `network_interface.enable_accelerated_networking` renamed to `accelerated_networking_enabled` (v5 provider). Old tfvars continue to work via `try()` fallback.
- **BREAKING (handled via compat fallback):** `network_interface.enable_ip_forwarding` renamed to `ip_forwarding_enabled` (v5 provider). Old tfvars continue to work via `try()` fallback.
- **BREAKING (handled via compat fallback):** `automatic_os_upgrade_policy.disable_automatic_rollback` renamed and boolean-inverted to `automatic_rollback_enabled` (v5 provider). Old tfvars continue to work via `!try()` fallback.
- **BREAKING (handled via compat fallback):** `automatic_os_upgrade_policy.enable_automatic_os_upgrade` renamed to `automatic_os_upgrade_enabled` (v5 provider). Old tfvars continue to work via `try()` fallback.
- **BREAKING (handled via compat fallback):** `data_disk.ultra_ssd_disk_iops_read_write` renamed to `disk_iops_read_write` (v5 provider). Old tfvars continue to work via `try()` fallback.
- **BREAKING (handled via compat fallback):** `data_disk.ultra_ssd_disk_mbps_read_write` renamed to `disk_mbps_read_write` (v5 provider). Old tfvars continue to work via `try()` fallback.
- Bumped child module `terraform-azurerm-caf-storage_accountV2` from `v1.0.3` to `v1.2.0`.
- Target provider version updated to `azurerm ~> 5.0` in `providers.tf`.
- ESLZ module source ref bumped to `v1.1.0`.

### Added

- `resilient_vm_creation_enabled` — resilient VM creation (v5 new arg).
- `resilient_vm_deletion_enabled` — resilient VM deletion (v5 new arg).
- `automatic_instance_repair.action` — repair action type (`Replace`, `Restart`, `Reimage`).
- `network_interface.auxiliary_mode` — NVA high-performance feature mode.
- `network_interface.auxiliary_sku` — NVA high-performance feature SKU.
- `network_interface.network_security_group_id` — NSG assignment on NIC.
- `providers.tf` with pinned `azurerm ~> 5.0`, `http ~> 3.0`, `random ~> 3.0` constraints.
- `.tflint.hcl` config using `call_module_type = "local"` (tflint >= v0.54.0 compatible).
- `.gitattributes` enforcing LF line endings.
- `tests/vmss_linux.tftest.hcl` — mock-provider unit tests (naming, defaults, v5 compat args).
- `tests/upgrade_compat.tftest.hcl` — state-chaining upgrade safety test.
- `.github/workflows/terraform-ci.yml` — CI pipeline with tflint and terraform validate.

- Bumped child module `terraform-azurerm-caf-load_balancer` from `v1.0.2` to `v2.0.0` (adds azurerm v5 compatibility: `enable_floating_ip` → `floating_ip_enabled`, `enable_tcp_reset` → `tcp_reset_enabled` internally).

### Removed

- `load_balancer` module call no longer passes `group`, `project`, `custom_data`, `user_data` — these arguments were removed from `terraform-azurerm-caf-load_balancer` v2.0.0 (VM-specific fields dropped from a pure load-balancer module). If any caller relied on `var.vmss.lb.custom_data` / `var.vmss.lb.user_data`, that capability is no longer available upstream.

### Fixed

- `regex("[^\\/]+"` → `regex("[^/]+"` in `locals.tf` and `secret.tf` (invalid Terraform regex escape).
- `output "vmss_linux"` now has `sensitive = true` to prevent mock-provider test failures.

