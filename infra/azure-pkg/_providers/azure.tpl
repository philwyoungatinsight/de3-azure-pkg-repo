terraform {
  required_version = ">= 1.3.0"
  required_providers {
    azurerm = { source = "hashicorp/azurerm", version = "~> 3.0" }
  }
}
provider "azurerm" {
  features {}
  subscription_id = "${SUBSCRIPTION_ID}"
  tenant_id       = "${TENANT_ID}"
  client_id       = "${CLIENT_ID}"
  client_secret   = "${CLIENT_SECRET}"
}
