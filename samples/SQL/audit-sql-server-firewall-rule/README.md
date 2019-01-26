# Audit SQL Server firewall rule

Audits the existence of a SQL Server [firewall rule](https://docs.microsoft.com/en-us/azure/sql-database/sql-database-firewall-configure).

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FSQL%2Faudit-sql-server-firewall-rule%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "audit-sql-server-firewall-rule" -DisplayName "Audit SQL Server firewall rule" -description "Audits the existence of a rule that enables traffic from a specific IP range to a SQL Server." -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/SQL/audit-sql-server-firewall-rule/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/SQL/audit-sql-server-firewall-rule/azurepolicy.parameters.json' -Mode Indexed
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope> -PolicyDefinition $definition
$assignment 
````



## Try with CLI

````cli

az policy definition create --name 'audit-sql-server-firewall-rule' --display-name 'Audit SQL Server virtual network rule' --description 'Audits the existence of a rule that enables traffic from a specific IP range to a SQL Server.' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/SQL/audit-sql-server-firewall-rule/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/SQL/audit-sql-server-firewall-rule/azurepolicy.parameters.json' --mode Indexed

az policy assignment create --name <assignmentname> --scope <scope> --policy "audit-sql-server-firewall-rule" 

````
