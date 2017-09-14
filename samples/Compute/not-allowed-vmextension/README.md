# Govern VM Extensions

This policy controls which VM extensions that are not allowed.

## Deploy Policy to Azure

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/?feature.customportal=false&microsoft_azure_policy=true#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade)

## How to create Policy Definition using PowerShell

````powershell
$definition = New-AzureRmPolicyDefinition -Name restrictVmExtensions `
                                          -DisplayName "Restricted VM extensions" `
                                          -Policy 'https://raw.githubusercontent.com/Azure/azure-policy-samples/master/samples/Compute/not-allowed-vmextension/azurepolicy.rules.json' `
                                          -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy-samples/master/samples/Compute/not-allowed-vmextension/azurepolicy.parameters.json'
````

## How to create Policy Definitions using AzureCLI

````cli

Az policy definition create –name restrictExtension –policyUri 'github.com/raw/foo/azurepolicy.rules.json' – parametersUri 'github.com/raw/bar/azurepolicy.parameters.json'

````
