# Audit VM Extensions

This policy will audit which VM extensions that are being deployed.

## Deploy Policy to Azure

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/?feature.customportal=false&microsoft_azure_policy=true#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade)

## How to create Policy Definition using PowerShell

````powershell
$definition = New-AzureRmPolicyDefinition -Name auditVmExtensions `
                                          -DisplayName "Audit VM extensions" `
                                          -Policy 'https://raw.githubusercontent.com/Azure/azure-policy-samples/master/samples/Compute/audit-vm-extension/azurepolicy.rules.json' `
                                          -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy-samples/master/samples/Compute/audit-vm-extension/azurepolicy.parameters.json'
````

## How to create Policy Definitions using AzureCLI

````cli

Az policy definition create –name auditVmExtension –policyUri 'github.com/raw/foo/azurepolicy.rules.json' – parametersUri 'github.com/raw/bar/azurepolicy.parameters.json'

````
