# Enforce Virtual Network Filtering on Cosmos DB accounts

This policy ensures Virtual Network Filtering is enabled on all Cosmos DB accounts

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FCosmosDB%2Fcosmos-db-vnet-filter%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "cosmos-db-vnet-filter" -DisplayName "Enforce Virtual Network Filtering on Cosmos DB accounts" -description "This policy ensures Virtual Network Filtering is enabled on all Cosmos DB accounts" -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/CosmosDB/cosmos-db-vnet-filter/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/CosmosDB/cosmos-db-vnet-filter/azurepolicy.parameters.json' -Mode Indexed
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope> -PolicyDefinition $definition
$assignment
````

## Try with CLI

````cli

az policy definition create --name 'cosmos-db-vnet-filter' --display-name 'Enforce Virtual Network Filtering on Cosmos DB accounts' --description 'This policy ensures Virtual Network Filtering is enabled on all Cosmos DB accounts' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/CosmosDB/cosmos-db-vnet-filter/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/CosmosDB/cosmos-db-vnet-filter/azurepolicy.parameters.json' --mode Indexed

az policy assignment create --name <assignmentname> --scope <scope> --policy "cosmos-db-vnet-filter" 

````
