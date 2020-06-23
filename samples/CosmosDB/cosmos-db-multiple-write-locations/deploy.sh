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
