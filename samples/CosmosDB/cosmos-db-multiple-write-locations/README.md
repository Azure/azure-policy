# Cosmos DB Multiple Write Locations

Audit or Deny whether Cosmos DB Multiple Write Locations is enabled.

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FCosmosDB%2Fcosmos-db-multiple-write-locations%2Fazurepolicy.json)

## Try with PowerShell

[Reference: New-AzPolicyDefinition](https://docs.microsoft.com/powershell/module/az.resources/new-azpolicydefinition)

[Reference: New-AzPolicyAssignment](https://docs.microsoft.com/powershell/module/az.resources/new-azpolicyassignment)

````powershell
$resourceGroupName = "cosmos"
$definitionName = "cosmosdb-multiple-write-locations"
$definitionDisplayName = "Cosmos DB Multiple Write Locations"
$definitionDescription = "Cosmos DB Multiple Write Locations: Audit or Deny whether setting is as specified"
$definitionRulesUrl = "https://raw.githubusercontent.com/Azure/azure-policy/master/samples/CosmosDB/cosmos-db-multiple-write-locations/azurepolicy.rules.json"
$definitionParamsUrl = "https://raw.githubusercontent.com/Azure/azure-policy/master/samples/CosmosDB/cosmos-db-multiple-write-locations/azurepolicy.parameters.json"
$assignmentName = "cosmosdb-multiple-write-locations-audit"
$assignmentDisplayName = "Cosmos DB Multiple Write Locations - Audit"

$definition = New-AzPolicyDefinition `
    -Name $definitionName `
    -Metadata '{"category":"Cosmos DB"}' `
    -DisplayName $definitionDisplayName `
    -Description $definitionDescription `
    -Policy $definitionRulesUrl `
    -Parameter $definitionParamsUrl `
    -Mode All

# Get the resource group ID so we can set it as policy assignment audit scope
$resourceGroupId = (Get-AzResourceGroup -Name $resourceGroupName).ResourceId

# Prepare parameter input object
$parameter = @{'multipleWriteLocationsMustBeEnabled' = $true; 'effect' = 'Audit'}

# Assign policy
New-AzPolicyAssignment `
    -Name $assignmentName `
    -DisplayName $assignmentDisplayName `
    -Scope $resourceGroupId `
    -PolicyDefinition $definition `
    -PolicyParameterObject $parameter
````

## Try with CLI

[Reference: az policy definition create](https://docs.microsoft.com/cli/azure/policy/definition?view=azure-cli-latest#az-policy-definition-create)

[Reference: az policy assignment create](https://docs.microsoft.com/cli/azure/policy/assignment?view=azure-cli-latest#az-policy-assignment-create)

````cli
#!/bin/bash

resourceGroupName="cosmos"
definitionName="cosmosdb-multiple-write-locations"
definitionDisplayName="Cosmos DB Multiple Write Locations"
definitionDescription="Cosmos DB Multiple Write Locations: Audit or Deny whether setting is as specified"
definitionRulesUrl="https://raw.githubusercontent.com/Azure/azure-policy/master/samples/CosmosDB/cosmos-db-multiple-write-locations/azurepolicy.rules.json"
definitionParamsUrl="https://raw.githubusercontent.com/Azure/azure-policy/master/samples/CosmosDB/cosmos-db-multiple-write-locations/azurepolicy.parameters.json"
assignmentName="cosmosdb-multiple-write-locations-audit"
assignmentDisplayName="Cosmos DB Multiple Write Locations - Audit"

az policy definition create \
    --name "$resourceGroupName" \
    --metadata "\"category\"=\"Cosmos DB\"" \
    --display-name "$definitionDisplayName" \
    --description "$definitionDescription" \
    --rules "$definitionRulesUrl" \
    --params "$definitionParamsUrl" \
    --mode All

Get the resource group ID so we can set it as policy assignment audit scope
resourceGroupId="$(az group show -n "$resourceGroupName" -o tsv --query "id")"

az policy assignment create \
    --sku standard \
    --name "$assignmentName" \
    --scope "$resourceGroupId" \
    --policy "$definitionName" \
    --params "{ \"multipleWriteLocationsMustBeEnabled\": { \"type\": \"boolean\", \"value\": $true } }"
````
