#--------------------------------------------------------------
# main_init.tf must be not touch! because main_init.tf is auto generate file.
# If you want to fix it, you should be fix /shell/files/main.template.tf.
#--------------------------------------------------------------

#--------------------------------------------------------------
# terraform state
#--------------------------------------------------------------
terraform {
  required_version = ">= 0.12"
  backend "azurerm" {
    storage_account_name = "##STORAGE_ACCOUNT_NAME##"
    container_name = "##CONTAINER_NAME##"
    key = "##KEY##"
  }
}

#--------------------------------------------------------------
# Provider Setting
#--------------------------------------------------------------
provider "azurerm" {
}
provider "azuread" {
 version = ">=0.3.0"
}