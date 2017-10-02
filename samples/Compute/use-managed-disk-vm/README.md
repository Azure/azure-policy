# Create VM using Managed Disk

Create VM using Managed Disk

## Deploy Policy to Azure

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/?feature.customportal=false&microsoft_azure_policy=true#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade)

## How to create Policy Definition using PowerShell

````powershell
$definition = New-AzureRmPolicyDefinition -Name manageddiskvm -DisplayName "Create VM using Managed Disk" -Policy 'https://raw.githubusercontent.com/Azure/azure-policy-samples/master/samples/Compute/use-managed-disk-vm/azurepolicy.rules.json'
````

## How to create Policy Definitions using AzureCLI

````cli

Az policy definition create –name manageddiskvm -rules 'https://raw.githubusercontent.com/Azure/azure-policy-samples/master/samples/Compute/use-managed-disk-vm/azurepolicy.rules.json'

````
