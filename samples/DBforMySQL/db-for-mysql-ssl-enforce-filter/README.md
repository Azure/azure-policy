# Enforce SSL on all DB for MySQL instances

This policy ensures SSL is enforced on all DB for MySQL instances

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FDBforMySQL%2Fdb-for-mysql-ssl-enforce-filter%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "db-for-mysql-ssl-enforce-filter" -DisplayName "Enforce SSL on all DB for MySQL instances" -description "This policy ensures SSL is enforced on all DB for MySQL instances" -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/DBforMySQL/db-for-mysql-ssl-enforce-filter/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/DBforMySQL/db-for-mysql-ssl-enforce-filter/azurepolicy.parameters.json' -Mode Indexed
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope> -PolicyDefinition $definition
$assignment
````

## Try with CLI

````cli

az policy definition create --name 'db-for-mysql-ssl-enforce-filter' --display-name 'Enforce SSL on all DB for MySQL instances' --description 'This policy ensures SSL is enforced on all DB for MySQL instances' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/DBforMySQL/db-for-mysql-ssl-enforce-filter/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/DBforMySQL/db-for-mysql-ssl-enforce-filter/azurepolicy.parameters.json' --mode Indexed

az policy assignment create --name <assignmentname> --scope <scope> --policy "db-for-mysql-ssl-enforce-filter" 

````
