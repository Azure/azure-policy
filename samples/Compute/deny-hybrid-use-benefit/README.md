# Deny Hybrid Use Benefit

This policy will deny Hybrid Use Benefit usage

## Deploy Policy to Azure

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/?feature.customportal=false&microsoft_azure_policy=true#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade)

## How to create Policy Definition using PowerShell

````powershell
$definition = New-AzureRmPolicyDefinition -Name denyHybridUseBenefit `
                                          -DisplayName "Deny hybrid use benefit" `
                                          -Policy 'https://raw.githubusercontent.com/Azure/azure-policy-samples/master/samples/Compute/deny-hybrid-use-benefit/azurepolicy.rules.json'
````

## How to create Policy Definitions using AzureCLI

````cli

Az policy definition create –name auditVmExtension –policyUri 'github.com/raw/foo/azurepolicy.rules.json' – parametersUri 'github.com/raw/bar/azurepolicy.parameters.json'

````
