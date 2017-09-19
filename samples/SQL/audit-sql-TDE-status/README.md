# Audit VM Extensions

This policy will Audit transparent data encryption status for SQL databases. It uses AuditIfNot Exists, which will trigger a delayed evaluation. 

## Deploy Policy to Azure

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/?feature.customportal=false&microsoft_azure_policy=true#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade)

## How to create Policy Definition using PowerShell

````powershell
New-AzureRmPolicyDefinition -Name audit-sql-tde-status -DisplayName "Audit transparent data encryption status" -Description "Audit transparent data encryption status for SQL databases" -Policy "https://raw.githubusercontent.com/Azure/azure-policy-samples/master/samples/SQL/audit-sql-TDE-status/azurepolicy.rules.json"
````

## How to create Policy Definitions using AzureCLI

````cli

Az policy definition create –name audit-sql-tde-status –policy "https://raw.githubusercontent.com/Azure/azure-policy-samples/master/samples/SQL/audit-sql-TDE-status/azurepolicy.rules.json"

````
