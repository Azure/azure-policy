# Allowed Application Gateway SKUs

This policy enables you to specify a set of application Gateway SKUs that your organization can deploy.

## Deploy Policy to Azure

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/?feature.customportal=false&microsoft_azure_policy=true#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade)

## How to create Policy Definition using PowerShell

````powershell
$definition = New-AzureRmPolicyDefinition -Name application-gateway-skus -Policy 'https://raw.githubusercontent.com/Azure/azure-policy-samples/master/samples/Network/application-gateway-skus/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy-samples/master/samples/Network/application-gateway-skus/azurepolicy.parameters.json'
````

## How to create Policy Definitions using AzureCLI

````cli

Az policy definition create –name application-gateway-skus -rules 'https://raw.githubusercontent.com/Azure/azure-policy-samples/master/samples/Network/application-gateway-skus/azurepolicy.rules.json' -params 'https://raw.githubusercontent.com/Azure/azure-policy-samples/master/samples/Network/application-gateway-skus/azurepolicy.parameters.json'

````
