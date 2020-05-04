#!/bin/bash

rules_url="https://raw.githubusercontent.com/Azure/azure-policy/master/samples/CosmosDB/audit-cosmosdb-throughput/azurepolicy.rules.json"
params_url="https://raw.githubusercontent.com/Azure/azure-policy/master/samples/CosmosDB/audit-cosmosdb-throughput/azurepolicy.parameters.json"

az policy definition create \
	--name 'audit-cosmosdb-throughput' \
	--display-name 'Audit Cosmos DB Throughput Exceeding Max' \
	--description 'Audit Cosmos DB Throughput Exceeding Max' \
	--rules $rules_url \
	--params $params_url \
	--mode All
