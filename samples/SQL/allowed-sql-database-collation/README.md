# Allowed SQL Database collations

This policy requires that only Azure SQL databases with the approved collation are deployed. You specify an array of approved collations.

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FSQL%2Fallowed-sql-database-collation%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "allowed-sql-database-collation" -DisplayName "Allowed SQL Database collations" -description "This policy requires that only Azure SQL databases with the approved collation are deployed" -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/SQL/allowed-sql-database-collation/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/SQL/allowed-sql-database-collation/azurepolicy.parameters.json' -Mode All
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope> -listOfAllowedCollations <Allowed database Collations> -PolicyDefinition $definition
$assignment 
````

## Try with CLI

````cli

az policy definition create --name 'allowed-sql-database-collation' --display-name 'Allowed SQL Database collations' --description 'This policy requires that only Azure SQL databases with the approved collation are deployed' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/SQL/allowed-sql-database-collation/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/SQL/allowed-sql-database-collation/azurepolicy.parameters.json' --mode All

az policy assignment create --name <assignmentname> --scope <scope> --params "{ 'listOfAllowedCollations': { 'value': ['SQL_Latin1_General_CP1_CI_AS', 'Latin1_General_BIN'] } }" --policy "allowed-sql-database-collation" 

````
