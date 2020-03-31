#!/bin/bash

az policy definition create \
	--name "audit-cosmosdb-throughput" \
	--display-name "Audit Cosmos DB Throughput Exceeding Max" \
	--description "This policy audits when CosmosDB throughput exceeds the specified maximum" \
	--rules "https://github.com/plzm/azure-policy/blob/cosmos-db-samples-plzm/samples/CosmosDB/audit-cosmosdb-throughput/azurepolicy.rules.json" \
	--params "https://raw.githubusercontent.com/plzm/azure-policy/cosmos-db-samples-plzm/samples/CosmosDB/audit-cosmosdb-throughput/azurepolicy.parameters.json" \
	--mode All
