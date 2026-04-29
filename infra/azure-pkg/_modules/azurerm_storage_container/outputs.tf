output "bucket_name" {
  description = "Blob container name (bucket analogue)."
  value       = azurerm_storage_container.this.name
}

output "storage_account_name" {
  description = "Storage Account that hosts the container."
  value       = azurerm_storage_account.this.name
}

output "storage_account_id" {
  description = "Resource ID of the Storage Account."
  value       = azurerm_storage_account.this.id
}

output "resource_group_name" {
  description = "Resource Group containing the storage account."
  value       = azurerm_resource_group.this.name
}

output "primary_blob_endpoint" {
  description = "Primary blob service endpoint URL."
  value       = azurerm_storage_account.this.primary_blob_endpoint
}
