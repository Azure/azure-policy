# Allowed Application Gateway SKUs

This policy enables you to specify a set of application Gateway SKUs that your organization can deploy.

## Deploy Policy to Azure

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/?feature.customportal=false&microsoft_azure_policy=true#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade)

## How to create Policy Definition using PowerShell

````powershell
$definition = New-AzureRmPolicyDefinition -Name audit-sql-server-threat-detection -Policy 'https://raw.githubusercontent.com/Azure/azure-policy-samples/master/samples/SQL/audit-sql-server-threat-detection/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy-samples/master/samples/SQL/audit-sql-server-threat-detection/azurepolicy.parameters.json'
````

## How to create Policy Definitions using AzureCLI

````cli

Az policy definition create –name audit-sql-server-threat-detection -rules 'https://raw.githubusercontent.com/Azure/azure-policy-samples/master/samples/SQL/audit-sql-server-threat-detection/azurepolicy.rules.json' -params 'https://raw.githubusercontent.com/Azure/azure-policy-samples/master/samples/SQL/audit-sql-server-threat-detection/azurepolicy.parameters.json'

````
