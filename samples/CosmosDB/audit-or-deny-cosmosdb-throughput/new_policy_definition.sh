#!/bin/bash

az policy definition create \
	--name "audit-or-deny-cosmosdb-throughput" \
	--display-name "Audit or Deny Cosmos DB Throughput Exceeding Max" \
	--description "This policy audits or denies when CosmosDB throughput exceeds the specified maximum" \
	--rules "https://github.com/plzm/azure-policy/blob/cosmos-db-samples-plzm/samples/CosmosDB/audit-or-deny-cosmosdb-throughput/azurepolicy.rules.json" \
	--params "https://raw.githubusercontent.com/plzm/azure-policy/cosmos-db-samples-plzm/samples/CosmosDB/audit-or-deny-cosmosdb-throughput/azurepolicy.parameters.json" \
	--mode All
