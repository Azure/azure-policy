# Audit non managed disk VM

Managed disk can help you simplify your VM disk managedment. Orgnizations can use this policy to audit non managed disk VMs. 

## Deploy Policy to Azure

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/?feature.customportal=false&microsoft_azure_policy=true#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade)

## How to create Policy Definition using PowerShell

````powershell
$definition = New-AzureRmPolicyDefinition -Name manageddiskvm -DisplayName "Audit non managed disk VM" -Policy 'https://raw.githubusercontent.com/Azure/azure-policy-samples/master/samples/Compute/audit-non-managed-disk-vm/azurepolicy.rules.json'
````

## How to create Policy Definitions using AzureCLI

````cli

Az policy definition create –name manageddiskvm -rules 'https://raw.githubusercontent.com/Azure/azure-policy-samples/master/samples/Compute/audit-non-managed-disk-vm/azurepolicy.rules.json'

````
