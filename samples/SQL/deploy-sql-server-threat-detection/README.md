# Deploy Threat Detection on SQL servers

This policy ensures that Threat Detection is enabled on SQL Servers.

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FSQL%2Fdeploy-sql-server-threat-detection%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "deploy-sql-server-threat-detection" -DisplayName "Deploy Threat Detection on SQL servers" -description "This policy ensures that Threat Detection is enabled on SQL Servers." -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/SQL/deploy-sql-server-threat-detection/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/SQL/deploy-sql-server-threat-detection/azurepolicy.parameters.json' -Mode Indexed
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope> -PolicyDefinition $definition
$assignment 
````

## Try with CLI

````cli

az policy definition create --name 'deploy-sql-server-threat-detection' --display-name 'Deploy Threat Detection on SQL servers' --description 'This policy ensures that Threat Detection is enabled on SQL Servers.' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/SQL/deploy-sql-server-threat-detection/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/SQL/deploy-sql-server-threat-detection/azurepolicy.parameters.json' --mode Indexed

az policy assignment create --name <assignmentname> --scope <scope> --policy "deploy-sql-server-threat-detection" 

````
