# Deny virtual networks to use user-defined route table

This policy will deny user-defined routing tables for virtual networks.

## Deploy Policy to Azure

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/?feature.customportal=false&microsoft_azure_policy=true#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade)

## How to create Policy Definition using PowerShell

````powershell
$definition = New-AzureRmPolicyDefinition -Name "vm-creation-in-approved-vnet" -DisplayName "Deny user-defined routing tables" -Policy 'https://raw.githubusercontent.com/Azure/azure-policy-samples/master/samples/Network/vm-creation-in-approved-vnet/azurepolicy.rules.json' -parameter 'https://raw.githubusercontent.com/Azure/azure-policy-samples/master/samples/Network/vm-creation-in-approved-vnet/azurepolicy.parameters.json'

New-AzureRmPolicyAssignment -Name test -Scope <scope> -PolicyDefinition $definition -subnetId <subnet-id>

````

## How to create Policy Definitions using AzureCLI

````cli

Az policy definition create –name "vm-creation-in-approved-vnet" -rules 'github.com/raw/foo/azurepolicy.rules.json' –params 'github.com/raw/bar/azurepolicy.parameters.json'

````