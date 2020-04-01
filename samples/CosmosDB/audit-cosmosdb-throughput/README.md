# Audit Cosmos DB Throughput Exceeding Max

Audit when Cosmos DB Shared or Dedicated [Throughput](https://docs.microsoft.com/azure/cosmos-db/set-throughput) exceeds the specified maximum.

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FCosmosDB%2Faudit-cosmosdb-throughput%2Fazurepolicy.json)

## Try with PowerShell

[Reference: New-AzPolicyDefinition](https://docs.microsoft.com/powershell/module/az.resources/new-azpolicydefinition)

[Reference: New-AzPolicyAssignment](https://docs.microsoft.com/powershell/module/az.resources/new-azpolicyassignment)

In addition to the following code blocks, [New-PolicyDefinition.ps1](New-PolicyDefinition.ps1) and [New-PolicyAssignment.ps1](New-PolicyAssignment.ps1) are available in this repo.

````powershell
$definition = New-AzPolicyDefinition `
    -Name "audit-cosmosdb-throughput" `
    -DisplayName "Audit Cosmos DB Throughput Exceeding Max" `
    -Description "Audit Cosmos DB Throughput Exceeding Max" `
    -Policy "https://raw.githubusercontent.com/Azure/azure-policy/master/samples/CosmosDB/audit-cosmosdb-throughput/azurepolicy.rules.json" `
    -Parameter "https://raw.githubusercontent.com/Azure/azure-policy/master/samples/CosmosDB/audit-cosmosdb-throughput/azurepolicy.parameters.json" `
    -Mode All

# Get the resource group ID so we can set it as policy assignment audit scope
$resource_group_id = (Get-AzResourceGroup -Name "my-resource-group-name").ResourceId

# Prepare parameter input object
$parameter = @{'throughputMax' = 400}

# Assign policy
New-AzPolicyAssignment `
    -Name "audit-cosmosdb-throughput-my-resource-group-name" `
    -DisplayName "Audit Cosmos DB Throughput in Resource Group my-resource-group-name" `
    -Scope $resource_group_id `
    -PolicyDefinition $definition `
    -PolicyParameterObject $parameter
````

## Try with CLI

[Reference: az policy definition create](https://docs.microsoft.com/cli/azure/policy/definition?view=azure-cli-latest#az-policy-definition-create)

[Reference: az policy assignment create](https://docs.microsoft.com/cli/azure/policy/assignment?view=azure-cli-latest#az-policy-assignment-create)

In addition to the following code blocks, [new-policy-definition.sh](new_policy_definition.sh) and [new-policy-assignment.sh](new_policy_assignment.sh) are available in this repo.

````cli
az policy definition create \
    --name "audit-cosmosdb-throughput" \
    --display-name "Audit Cosmos DB Throughput Exceeding Max" \
    --description "Audit Cosmos DB Throughput Exceeding Max" \
    --rules "https://raw.githubusercontent.com/Azure/azure-policy/master/samples/CosmosDB/audit-cosmosdb-throughput/azurepolicy.rules.json" \
    --params "https://raw.githubusercontent.com/Azure/azure-policy/master/samples/CosmosDB/audit-cosmosdb-throughput/azurepolicy.parameters.json" \
    --mode All

# Get the resource group ID so we can set it as policy assignment audit scope
resource_group_id="$(az group show -n "my-resource-group-name" -o tsv --query "id")"

az policy assignment create \
    --sku standard \
    --name "my-policy-assignment-name" \
    --scope "$resource_group_id" \
    --policy "audit-cosmosdb-throughput" \
    --params "{ \"throughputMax\": { \"type\": \"integer\", \"value\": 400 } }"
````
