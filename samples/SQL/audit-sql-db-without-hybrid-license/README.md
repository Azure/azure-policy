# Audit SQL DB without Hybrid Licensing

Generates audit record if SQL DB is not configured for hybrid license

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FSQL%2Faudit-sql-db-without-hybrid-license%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "audit-sql-db-without-hybrid-license" -DisplayName "Audit SQL DB without Hybrid Licensing" -description "Generates audit record if SQL DB is not configured for hybrid license" -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/SQL/audit-sql-db-without-hybrid-license/azurepolicy.rules.json' -Mode Indexed
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope> -PolicyDefinition $definition
$assignment
````

## Try with CLI

````cli

az policy definition create --name 'audit-sql-db-without-hybrid-license' --display-name 'Audit SQL DB without Hybrid Licensing' --description 'Generates audit record if SQL DB is not configured for hybrid license' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/SQL/audit-sql-db-without-hybrid-license/azurepolicy.rules.json' --mode Indexed

az policy assignment create --name <assignmentname> --scope <scope> --policy "audit-sql-db-without-hybrid-license"

````
