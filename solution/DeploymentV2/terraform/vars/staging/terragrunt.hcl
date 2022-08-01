remote_state {
  backend = "azurerm"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    # You need to update the resource group and storage account here. 
    # You should have created these with the Prepare.ps1 script.
    resource_group_name  = "lockboxdev02"
    storage_account_name = "lockboxdev02state"
    container_name       = "tstate"
    key                  = "terraform.tfstate"
  }
}

# These inputs are provided to the terraform variables when deploying the environment
# If you are deploying using pipelines, these can be overridden from environment variables
# using TF_VAR_variablename
inputs = {
  prefix                                = "ark"              # All azure resources will be prefixed with this
  domain                                = "arkahna.io"              # Used when configuring AAD config for Azure functions 
  tenant_id                             = "0fee3d31-b963-4a1c-8f4a-ca367205aa65"           # This is the Azure AD tenant ID
  subscription_id                       = "687fe1ae-a520-4f86-b921-a80664c40f9b"     # The azure subscription id to deploy to
  resource_location                     = "Australia East"        # The location of the resources
  resource_group_name                   = "lockboxdev02"          # The resource group all resources will be deployed to
  owner_tag                             = "Arkahna"               # Owner tag value for Azure resources
  environment_tag                       = "stg"                   # This is used on Azure tags as well as all resource names
  ip_address                            = "101.179.198.119"          # This is the ip address of the agent/current IP. Used to create firewall exemptions.
  deploy_web_app                        = true
  deploy_function_app                   = true
  deploy_custom_terraform               = false # This is whether the infrastructure located in the terraform_custom folder is deployed or not.
  deploy_sentinel                       = false
  deploy_purview                        = false  
  deploy_synapse                        = true
  deploy_metadata_database              = true
  is_vnet_isolated                      = true
  publish_web_app                       = false
  publish_function_app                  = true
  publish_sample_files                  = false
  publish_metadata_database             = false
  publish_sql_logins                    = false
  configure_networking                  = true
  publish_datafactory_pipelines         = false
  publish_web_app_addcurrentuserasadmin = true
  deploy_synapse_sqlpool                = false
  deploy_selfhostedsql                  = false
  is_onprem_datafactory_ir_registered   = true
  deploy_h2o-ai = false
  synapse_git_toggle_integration = true
  synapse_git_repository_owner = "h-sha"
  synapse_git_repository_name = "testLockbox"
  synapse_git_repository_branch_name = "lockboxdev02"
  synapse_git_repository_root_folder = "/Synapse"
  synapse_git_use_pat = false
  synapse_git_pat = ""

  
} 
