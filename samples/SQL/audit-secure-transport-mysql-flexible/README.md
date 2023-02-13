# Require Secure Transport shoud be enabled for MySQL flexible servers

Azure Database for MySQL flexible servers supports connecting your Azure Database for MySQL flexible servers to client applications using Secure Sockets Layer (SSL). Enforcing SSL connections between your database server and your client applications helps protect against 'man in the middle' attacks by encrypting the data stream between the server and your application. This configuration enforces that SSL is always enabled for accessing your database server.

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FSQL%2Faudit-secure-transport-mysql-flexible%2Fazurepolicy.json)

## Try with PowerShell

```powershell
$definition = New-AzPolicyDefinition -Name "audit-secure-transport-mysql-flexible" -DisplayName "Require Secure Transport shoud be enabled for MySQL flexible servers" -description "Azure Database for MySQL flexible servers supports connecting your Azure Database for MySQL flexible servers to client applications using Secure Sockets Layer (SSL). Enforcing SSL connections between your database server and your client applications helps protect against 'man in the middle' attacks by encrypting the data stream between the server and your application. This configuration enforces that SSL is always enabled for accessing your database server." -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/SQL/audit-secure-transport-mysql-flexible/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/SQL/audit-secure-transport-mysql-flexible/azurepolicy.parameters.json' -Mode Indexed
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope> -PolicyDefinition $definition
$assignment
```

## Try with CLI

```cli

az policy definition create --name 'audit-secure-transport-mysql-flexible' --display-name 'Require Secure Transport shoud be enabled for MySQL flexible servers' --description 'Azure Database for MySQL flexible servers supports connecting your Azure Database for MySQL flexible servers to client applications using Secure Sockets Layer (SSL). Enforcing SSL connections between your database server and your client applications helps protect against 'man in the middle' attacks by encrypting the data stream between the server and your application. This configuration enforces that SSL is always enabled for accessing your database server.' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/SQL/audit-secure-transport-mysql-flexible/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/SQL/audit-secure-transport-mysql-flexible/azurepolicy.parameters.json' --mode All

az policy assignment create --name <assignmentname> --scope <scope> --policy "audit-secure-transport-mysql-flexible"

```
