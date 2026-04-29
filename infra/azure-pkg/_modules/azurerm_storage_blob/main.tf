resource "azurerm_storage_blob" "this" {
  name                   = var.object_name
  storage_account_name   = var.storage_account_name
  storage_container_name = var.container_name
  type                   = "Block"
  source_content         = var.content
  content_type           = var.content_type
  metadata               = var.metadata
}
