# Audit CosmosDB IP Range Filter Rule

Audits the existence of the CosmosDB [IP firewall](https://docs.microsoft.com/en-us/azure/cosmos-db/firewall-support) configuration

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FCosmosDB%2Faudit-cosmosdb-ip-range-filter%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "audit-cosmosdb-ip-range-filter" -DisplayName "Audits the existence of an IP Range Filter coniguration on CosmosDB accounts" -description "Audits the existence of the CosmosDB IP firewall configuration" -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/CosmosDB/audit-cosmosdb-ip-range-filter/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/CosmosDB/audit-cosmosdb-ip-range-filter/azurepolicy.parameters.json' -Mode All
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope>  -setting <Audit Setting> -PolicyDefinition $definition
$assignment 
````

## Try with CLI

````cli

az policy definition create --name 'audit-cosmosdb-ip-range-filter' --display-name 'Audits the existence of an IP Range Filter coniguration on CosmosDB accounts' --description 'Audits the existence of the CosmosDB IP firewall configuration' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/CosmosDB/audit-cosmosdb-ip-range-filter/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/CosmosDB/audit-cosmosdb-ip-range-filter/azurepolicy.parameters.json' --mode All

az policy assignment create --name <assignmentname> --scope <scope> --policy "audit-cosmosdb-ip-range-filter" 

````