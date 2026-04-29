resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_storage_account" "this" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.this.name
  location                 = azurerm_resource_group.this.location
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = var.tags

  # Hierarchical Namespace enables ADLS Gen2 (true folder semantics).
  # Cannot be changed after account creation.
  is_hns_enabled = var.hns_enabled

  blob_properties {
    versioning_enabled = var.versioning_enabled

    dynamic "delete_retention_policy" {
      for_each = var.blob_soft_delete_days > 0 ? [1] : []
      content {
        days = var.blob_soft_delete_days
      }
    }

    dynamic "container_delete_retention_policy" {
      for_each = var.container_soft_delete_days > 0 ? [1] : []
      content {
        days = var.container_soft_delete_days
      }
    }
  }

  # Account-level immutability (WORM). Locked state is irreversible.
  dynamic "immutability_policy" {
    for_each = var.immutability_policy != null ? [var.immutability_policy] : []
    content {
      allow_protected_append_writes = immutability_policy.value.allow_protected_append_writes
      state                         = immutability_policy.value.state
      period_since_creation_in_days = immutability_policy.value.period_since_creation_in_days
    }
  }
}

resource "azurerm_storage_container" "this" {
  name                  = var.container_name
  storage_account_name  = azurerm_storage_account.this.name
  container_access_type = "private"
}

resource "azurerm_storage_management_policy" "this" {
  count              = length(var.lifecycle_rules) > 0 ? 1 : 0
  storage_account_id = azurerm_storage_account.this.id

  dynamic "rule" {
    for_each = var.lifecycle_rules
    content {
      name    = rule.value.name
      enabled = rule.value.enabled
      filters {
        blob_types   = rule.value.blob_types
        prefix_match = rule.value.prefix_match
      }
      actions {
        dynamic "base_blob" {
          for_each = (
            rule.value.tier_to_cool_after_days_since_modification != null ||
            rule.value.tier_to_cold_after_days_since_modification != null ||
            rule.value.tier_to_archive_after_days_since_modification != null ||
            rule.value.delete_after_days_since_modification != null
          ) ? [1] : []
          content {
            tier_to_cool_after_days_since_modification_greater_than    = rule.value.tier_to_cool_after_days_since_modification
            tier_to_cold_after_days_since_modification_greater_than    = rule.value.tier_to_cold_after_days_since_modification
            tier_to_archive_after_days_since_modification_greater_than = rule.value.tier_to_archive_after_days_since_modification
            delete_after_days_since_modification_greater_than          = rule.value.delete_after_days_since_modification
          }
        }
        dynamic "snapshot" {
          for_each = rule.value.snapshot_delete_after_days != null ? [1] : []
          content {
            delete_after_days_since_creation_greater_than = rule.value.snapshot_delete_after_days
          }
        }
        dynamic "version" {
          for_each = rule.value.version_delete_after_days != null ? [1] : []
          content {
            delete_after_days_since_creation = rule.value.version_delete_after_days
          }
        }
      }
    }
  }
}
