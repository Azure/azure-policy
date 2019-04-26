# Audit CosmosDB Automatic Failover Rule

Audits the existence of the CosmosDB [Automatic Failover](https://docs.microsoft.com/en-us/azure/cosmos-db/high-availability) configuration


## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FCosmosDB%2Faudit-cosmosdb-autofailover-georeplication%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "audit-cosmosdb-autofailover-georeplication" -DisplayName "Audit Automatic Failover for CosmosDB accounts" -description "This policy audits Automatic Failover for CosmosDB accounts" -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/CosmosDB/audit-cosmosdb-autofailover-georeplication/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/CosmosDB/audit-cosmosdb-autofailover-georeplication/azurepolicy.parameters.json' -Mode All
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope>  -setting <Audit Setting> -PolicyDefinition $definition
$assignment 
````



## Try with CLI

````cli

az policy definition create --name 'audit-cosmosdb-autofailover-georeplication' --display-name 'Audit Automatic Failover for CosmosDB accounts' --description 'This policy audits Automatic Failover for CosmosDB accounts' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/CosmosDB/audit-cosmosdb-autofailover-georeplication/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/CosmosDB/audit-cosmosdb-autofailover-georeplication/azurepolicy.parameters.json' --mode All

az policy assignment create --name <assignmentname> --scope <scope> --policy "audit-cosmosdb-autofailover-georeplication" 

````