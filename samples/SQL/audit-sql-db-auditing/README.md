# Audit SQL DB Level Audit Setting

Audit DB level audit setting for SQL databases

## Deploy Policy to Azure

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/?feature.customportal=false&microsoft_azure_policy=true#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade)

## How to create Policy Definition using PowerShell

````powershell
$definition = New-AzureRmPolicyDefinition -Name audit-sql-db-auditing -Policy 'https://raw.githubusercontent.com/Azure/azure-policy-samples/master/samples/SQL/audit-sql-db-auditing/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy-samples/master/samples/SQL/audit-sql-db-auditing/azurepolicy.parameters.json'
````

## How to create Policy Definitions using AzureCLI

````cli

Az policy definition create –name auditNworkWatcher -rules 'https://raw.githubusercontent.com/Azure/azure-policy-samples/master/samples/SQL/audit-sql-db-auditing/azurepolicy.rules.json' -params 'https://raw.githubusercontent.com/Azure/azure-policy-samples/master/samples/SQL/audit-sql-db-auditing/azurepolicy.parameters.json'
````
