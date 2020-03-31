# Handle CosmosDB Dedicated/Shared Throughput Level Exceeding Max

Audits or Denies when CosmosDB Shared (Database) or Dedicated (Collection) [Throughput](https://docs.microsoft.com/azure/cosmos-db/set-throughput) exceeds the specified maximum.

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FCosmosDB%2Faudit-or-deny-cosmosdb-throughput%2Fazurepolicy.json)

## Try with PowerShell

[Reference: New-AzPolicyDefinition](https://docs.microsoft.com/powershell/module/az.resources/new-azpolicydefinition)
[Reference: New-AzPolicyAssignment](https://docs.microsoft.com/powershell/module/az.resources/new-azpolicyassignment)

````powershell
$definition = New-AzPolicyDefinition -Name "audit-or-deny-cosmosdb-throughput" -DisplayName "Handle CosmosDB Dedicated/Shared Throughput Level Exceeding Max" -description "This policy audits or denies when CosmosDB throughput exceeds the specified maximum" -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/CosmosDB/audit-or-deny-cosmosdb-throughput/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/CosmosDB/audit-or-deny-cosmosdb-throughput/azurepolicy.parameters.json' -Mode All
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope> -setting <Audit Setting> -PolicyDefinition $definition
$assignment 
````

## Try with CLI

[Reference: az policy definition create](https://docs.microsoft.com/cli/azure/policy/definition?view=azure-cli-latest#az-policy-definition-create)
[Reference: az policy assignment create](https://docs.microsoft.com/cli/azure/policy/assignment?view=azure-cli-latest#az-policy-assignment-create)

````cli

az policy definition create --name 'audit-or-deny-cosmosdb-throughput' --display-name 'Handle CosmosDB Dedicated/Shared Throughput Level Exceeding Max' --description 'This policy audits or denies when CosmosDB throughput exceeds the specified maximum' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/CosmosDB/audit-or-deny-cosmosdb-throughput/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/CosmosDB/audit-or-deny-cosmosdb-throughput/azurepolicy.parameters.json' --mode All

az policy assignment create --name <assignmentname> --scope <scope> --policy "audit-or-deny-cosmosdb-throughput" 

````
