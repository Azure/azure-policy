#!/bin/bash

# Variables
resource_group_name="my-resource-group-name"
definition_name="audit-cosmosdb-throughput"
assignment_name="audit-cosmosdb-throughput-$resource_group_name"
display_name="Audit Cosmos DB Throughput in Resource Group $resource_group_name"
max_rus=400

# Get the resource group ID so we can set it as policy assignment audit scope
resource_group_id="$(az group show -n "$resource_group_name" -o tsv --query "id")"

# Assign policy
az policy assignment create \
	--sku standard \
	--name "$assignment_name" \
	--display-name "$display_name" \
	--scope "$resource_group_id" \
	--policy "$definition_name" \
	--params "{ \"throughputMax\": { \"type\": \"integer\", \"value\": $max_rus } }"
