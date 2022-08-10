#----------------------------------------------------------------------------------------------------------------
# You must be logged into the Azure CLI to run this script
#----------------------------------------------------------------------------------------------------------------
# This script will: 
# - Deploy the required AAD objects (Application Registrations etc)
# 
# This is intended for creating a once off deployment from your development machine. You should setup the
# GitHub actions for your long term prod/non-prod environments
#
# Intructions
# - Ensure that you have run the Prepare.ps1 script first. This will prepare your azure subscription for deployment
# - Ensure that you have run az login and az account set
# - Ensure you have Contributor Access to the subscription you are deploying to. 
# - Ensure you have Application.ReadWrite.OwnedBy on the Azure AD. 
# - Run this script
# 
# You can run this script multiple times if needed.
# 
#----------------------------------------------------------------------------------------------------------------
param (
    [Parameter(Mandatory=$false)]
    [string]$FeatureTemplate=""
)

#------------------------------------------------------------------------------------------------------------
# Module Imports #Mandatory
#------------------------------------------------------------------------------------------------------------
import-Module ./../pwshmodules/GatherOutputsFromTerraform.psm1 -force
import-Module ./../pwshmodules/Deploy_0_Prep.psm1 -force
#------------------------------------------------------------------------------------------------------------
# Preparation #Mandatory
#------------------------------------------------------------------------------------------------------------
$PathToReturnTo = (Get-Location).Path
$deploymentFolderPath = Convert-Path -Path ((Get-Location).tostring() + './../')

$gitDeploy = ([System.Environment]::GetEnvironmentVariable('gitDeploy')  -eq 'true')
$skipTerraformDeployment = ([System.Environment]::GetEnvironmentVariable('skipTerraformDeployment')  -eq 'true')
$ipaddress = $env:TF_VAR_ip_address
$ipaddress2 = $env:TF_VAR_ip_address2

PrepareDeployment -gitDeploy $gitDeploy -deploymentFolderPath $deploymentFolderPath -FeatureTemplate $FeatureTemplate -PathToReturnTo $PathToReturnTo

#------------------------------------------------------------------------------------------------------------
# Get Outputs #Mandatory
#------------------------------------------------------------------------------------------------------------
$tout = GatherOutputsFromTerraform -TerraformFolderPath $PathToReturnTo

#------------------------------------------------------------------------------------------------------------
# Publish
#------------------------------------------------------------------------------------------------------------
import-Module ./../pwshmodules/Deploy_4_PrivateLinks.psm1 -force
DeployPrivateLinks -tout $tout  

import-Module ./../pwshmodules/Deploy_5_WebApp.psm1 -force
DeployWebApp -tout $tout  -deploymentFolderPath $deploymentFolderPath -PathToReturnTo $PathToReturnTo

import-Module ./../pwshmodules/Deploy_6_FuncApp.psm1 -force
DeployFuncApp -tout $tout  -deploymentFolderPath $deploymentFolderPath -PathToReturnTo $PathToReturnTo

import-Module ./../pwshmodules/Deploy_7_MetadataDB.psm1 -force
DeployMataDataDB -publish_metadata_database $true -tout $tout  -deploymentFolderPath $deploymentFolderPath -PathToReturnTo $PathToReturnTo

import-Module ./../pwshmodules/Deploy_9_DataFactory.psm1 -force
DeployDataFactoryAndSynapseArtefacts -tout $tout  -deploymentFolderPath $deploymentFolderPath -PathToReturnTo $PathToReturnTo

import-Module ./../pwshmodules/Deploy_10_SampleFiles.psm1 -force
DeploySampleFiles -tout $tout  -deploymentFolderPath $deploymentFolderPath -PathToReturnTo $PathToReturnTo

#import-Module ./../pwshmodules/ConfigureAzurePurview.psm1 -force
#ConfigureAzurePurview -tout $tout  