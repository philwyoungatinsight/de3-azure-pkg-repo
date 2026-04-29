variable "resource_group_name" {
  description = "Azure Resource Group to create resources in."
  type        = string
}

variable "storage_account_name" {
  description = "Globally unique Azure Storage Account name (3-24 lowercase alphanumeric)."
  type        = string
}

variable "container_name" {
  description = "Blob container name."
  type        = string
  default     = "test-data"
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources."
  type        = map(string)
  default     = {}
}

variable "hns_enabled" {
  description = "Enable Hierarchical Namespace (ADLS Gen2 / true folder semantics). Cannot be changed after account creation."
  type        = bool
  default     = false
}

variable "versioning_enabled" {
  description = "Enable blob versioning to retain previous object versions on overwrite or delete."
  type        = bool
  default     = false
}

variable "blob_soft_delete_days" {
  description = "Blob soft-delete retention window in days (1-365). 0 = disabled. Azure portal default: 7."
  type        = number
  default     = 7
  validation {
    condition     = var.blob_soft_delete_days >= 0 && var.blob_soft_delete_days <= 365
    error_message = "blob_soft_delete_days must be between 0 (disabled) and 365."
  }
}

variable "container_soft_delete_days" {
  description = "Container soft-delete retention window in days (1-365). 0 = disabled. Azure portal default: 7."
  type        = number
  default     = 7
  validation {
    condition     = var.container_soft_delete_days >= 0 && var.container_soft_delete_days <= 365
    error_message = "container_soft_delete_days must be between 0 (disabled) and 365."
  }
}

variable "lifecycle_rules" {
  description = "Lifecycle management rules to automate cost-saving tier transitions and deletion. Each rule must define at least one action (base_blob, snapshot, or version)."
  type = list(object({
    name         = string
    enabled      = optional(bool, true)
    prefix_match = optional(list(string), [])
    blob_types   = optional(list(string), ["blockBlob"])

    # base_blob actions – days since last modification
    tier_to_cool_after_days_since_modification    = optional(number)
    tier_to_cold_after_days_since_modification    = optional(number)
    tier_to_archive_after_days_since_modification = optional(number)
    delete_after_days_since_modification          = optional(number)

    # snapshot actions
    snapshot_delete_after_days = optional(number)

    # version actions (requires versioning_enabled = true)
    version_delete_after_days = optional(number)
  }))
  default = []
}

variable "immutability_policy" {
  description = "Account-level immutability policy (WORM). null = disabled. WARNING: Locked state is irreversible."
  type = object({
    allow_protected_append_writes = bool
    state                         = string # Disabled | Unlocked | Locked
    period_since_creation_in_days = number
  })
  default = null
  validation {
    condition     = var.immutability_policy == null || contains(["Disabled", "Unlocked", "Locked"], try(var.immutability_policy.state, "Disabled"))
    error_message = "immutability_policy.state must be Disabled, Unlocked, or Locked."
  }
}
