variable "storage_account_name" {
  description = "Azure Storage Account that hosts the container."
  type        = string
}

variable "container_name" {
  description = "Blob container name where the object will be stored."
  type        = string
}

variable "object_name" {
  description = "Blob name (key) within the container."
  type        = string
  default     = "all-config"
}

variable "content" {
  description = "Inline string content to upload as a Block blob."
  type        = string
}

variable "content_type" {
  description = "Content-Type metadata for the blob."
  type        = string
  default     = "application/json"
}

variable "metadata" {
  description = "Key/value metadata pairs to attach to the blob."
  type        = map(string)
  default     = {}
}
