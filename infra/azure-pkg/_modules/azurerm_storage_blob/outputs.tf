output "bucket_name" {
  description = "Blob container name (bucket analogue)."
  value       = azurerm_storage_blob.this.storage_container_name
}

output "storage_account_name" {
  description = "Storage account that hosts the blob."
  value       = azurerm_storage_blob.this.storage_account_name
}

output "object_name" {
  description = "Name (key) of the blob in the container."
  value       = azurerm_storage_blob.this.name
}

output "url" {
  description = "URL of the blob."
  value       = azurerm_storage_blob.this.url
}
