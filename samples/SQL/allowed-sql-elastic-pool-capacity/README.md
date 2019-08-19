# Allowed SQL Elastic Pool capacity

This policy restricts the maximum capacity (vcores) defined for a SQL Elastic Pool

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FSQL%2Fallowed-sql-elastic-pool-capacity%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "allowed-sql-elastic-pool-capacity" -DisplayName "Allowed SQL Elastic Pool capacity" -description "This policy restricts the maximum capacity (vcores) defined for a SQL Elastic Pool" -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/SQL/allowed-sql-elastic-pool-capacity/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/SQL/allowed-sql-elastic-pool-capacity/azurepolicy.parameters.json' -Mode All
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope> -MaxPoolCapacityVCores <Allowed vcores> -PolicyDefinition $definition
$assignment 
````

## Try with CLI

````cli

az policy definition create --name 'allowed-sql-elastic-pool-capacity' --display-name 'Allowed SQL Elastic Pool capacity' --description 'This policy restricts the maximum capacity (vcores) defined for a SQL Elastic Pool' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/SQL/allowed-sql-elastic-pool-capacity/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/SQL/allowed-sql-elastic-pool-capacity/azurepolicy.parameters.json' --mode All

az policy assignment create --name <assignmentname> --scope <scope> --params "{ 'MaxPoolCapacityVCores': { 'value': '8' } }" --policy "allowed-sql-elastic-pool-capacity" 

````
