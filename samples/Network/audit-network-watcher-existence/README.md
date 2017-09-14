# Audit for Network Watcher existence

This policy will audit Network Watchers existence in a selected location where virtual networks are present.

## Deploy Policy to Azure

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/?feature.customportal=false&microsoft_azure_policy=true#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade)

## How to create Policy Definition using PowerShell

````powershell
$definition = New-AzureRmPolicyDefinition -Name auditNetworkWatcher `
                                          -DisplayName "Audit for Network watcher absence" `
                                          -Policy 'https://raw.githubusercontent.com/Azure/azure-policy-samples/master/samples/Network/audit-network-watcher-existence/azurepolicy.rules.json' `
                                          -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy-samples/master/samples/Network/audit-network-watcher-existence/azurepolicy.parameters.json'
````

## How to create Policy Definitions using AzureCLI

````cli

Az policy definition create –name auditNworkWatcher –policyUri 'github.com/raw/foo/azurepolicy.rules.json' – parametersUri 'github.com/raw/bar/azurepolicy.parameters.json'

````
