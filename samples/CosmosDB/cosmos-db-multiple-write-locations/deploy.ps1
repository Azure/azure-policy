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
