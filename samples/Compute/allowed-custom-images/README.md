# Govern approved VM Images

This policy let you control the approved VM images.

## Deploy Policy to Azure

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/?feature.customportal=false&microsoft_azure_policy=true#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade)

## How to create Policy Definition using PowerShell

````powershell
$definition = New-AzureRmPolicyDefinition -Name approvedVMImages -DisplayName "Approved VM images" -Policy 'https://raw.githubusercontent.com/Azure/azure-policy-samples/master/samples/Compute/allowed-custom-images/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy-samples/master/samples/Compute/allowed-custom-images/azurepolicy.parameters.json'
````

## How to create Policy Definitions using AzureCLI

````cli

Az policy definition create –name approvedVMImages -rules 'https://raw.githubusercontent.com/Azure/azure-policy-samples/master/samples/Compute/allowed-custom-images/azurepolicy.rules.json' -params 'https://raw.githubusercontent.com/Azure/azure-policy-samples/master/samples/Compute/allowed-custom-images/azurepolicy.parameters.json'

````
