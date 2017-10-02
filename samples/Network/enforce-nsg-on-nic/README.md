# Enforce NSG association with virtual network interfaces

This policy will enforce that a Network Security Group is associated with virtual network interface cards.

## Deploy Policy to Azure

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/?feature.customportal=false&microsoft_azure_policy=true#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade)

## How to create Policy Definition using PowerShell

````powershell
$definition = New-AzureRmPolicyDefinition -Name nsgNicEnforcement `
                                          -DisplayName "Enforce NSG on virtual network interfaces" `
                                          -Policy 'https://raw.githubusercontent.com/Azure/azure-policy-samples/master/samples/Network/enforce-nsg-on-nic/azurepolicy.rules.json' `
                                          -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy-samples/master/samples/Network/enforce-nsg-on-nic/azurepolicy.parameters.json'
````

## How to create Policy Definitions using AzureCLI

````cli

Az policy definition create –name auditNworkWatcher –policyUri 'github.com/raw/foo/azurepolicy.rules.json' – parametersUri 'github.com/raw/bar/azurepolicy.parameters.json'

````
