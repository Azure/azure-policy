# Audit SQL Server Level Audit Setting

Audit Audit Setting for SQL Server

## Deploy Policy to Azure

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/?feature.customportal=false&microsoft_azure_policy=true#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade)

## How to create Policy Definition using PowerShell

````powershell
$definition = New-AzureRmPolicyDefinition -Name audit-sql-server-auditing -Policy 'https://raw.githubusercontent.com/Azure/azure-policy-samples/master/samples/SQL/audit-sql-server-auditing/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy-samples/master/samples/SQL/audit-sql-server-auditing/azurepolicy.parameters.json'
````

## How to create Policy Definitions using AzureCLI

````cli

Az policy definition create –name audit-sql-server-auditing -rules 'https://raw.githubusercontent.com/Azure/azure-policy-samples/master/samples/SQL/audit-sql-server-auditing/azurepolicy.rules.json' -params 'https://raw.githubusercontent.com/Azure/azure-policy-samples/master/samples/SQL/audit-sql-server-auditing/azurepolicy.parameters.json'

````
