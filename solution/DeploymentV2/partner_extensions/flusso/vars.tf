#---------------------------------------------------------------
# Provider details
#---------------------------------------------------------------
variable "ip_address" {
  description = "The CICD ipaddress. We add an IP whitelisting to allow the setting of keyvault secrets"
  type        = string
}

variable "tenant_id" {
  description = "The AAD tenant ID"
  type        = string
}

variable "subscription_id" {
  description = "The Azure Subscription ID"
  type        = string
}

variable "resource_location" {
  description = "The Azure Region being deployed to."
  type        = string
  default     = "Australia East"
}

variable "resource_group_name" {
  type = string
}
#---------------------------------------------------------------
# Tags
#---------------------------------------------------------------

variable "owner_tag" {
  description = "The tags to apply to resources."
  type        = string
  default     = "opensource.microsoft.com"
}

variable "author_tag" {
  description = "The tags to apply to resources."
  type        = string
  default     = "opensource.microsoft.com"
}

variable "environment_tag" {
  description = "The name of the environment. Don't use spaces"
  default     = "dev"
  type        = string
}


#---------------------------------------------------------------
# Naming Prefix Settings
#---------------------------------------------------------------
variable "prefix" {
  description = "The prefix value to be used for autogenerated naming conventions"
  default     = "ark"
  type        = string
}
variable "app_name" {
  description = "The app_name suffix value to be used for autogenerated naming conventions"
  default     = "ads"
  type        = string
}


#---------------------------------------------------------------
# Networking
#---------------------------------------------------------------
variable "is_vnet_isolated" {
  description = "Whether to deploy the resources as vnet attached / private linked"
  default     = true
  type        = bool
}



#---------------------------------------------------------------
# User Access and Ownership/
#---------------------------------------------------------------

variable "azure_sql_aad_administrators" {
   description = "List of Azure SQL Administrators"
   type = map(string)
   default = {}
}

variable "azure_purview_data_curators" {
   description = "List of Azure Purview Data Curators for default root"
   type = map(string)
   default = {}
}

variable "resource_owners" {
  description = "A web app Azure security group used for admin access."
  default = {	
  }
  type        = map(string)
}


#---------------------------------------------------------------
# IXUP
#---------------------------------------------------------------
variable "deploy_ixup_encryption_gw" {
  description = "Feature toggle for deploying IXUP Encrption Gateway"
  default     = false
  type        = bool
}

# IXUP Encryption gateway VM
variable "ixup_egw_password" {
  description = "Password for the Encryption Gateway box"
  type        = string
}

variable "ixup_egw_vm_size" {
  description = "Size for Encryption Gateway Virtual Machine"
  default     = "Standard_B2s"
}