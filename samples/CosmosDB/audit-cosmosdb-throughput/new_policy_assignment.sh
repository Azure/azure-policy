#!/bin/bash

resource_group_name="cosmos"
definition_name="audit-cosmosdb-throughput"
assignment_name="audit-cosmosdb-throughput"

resource_group_id="$(az group show -n "$resource_group_name" -o tsv --query "id")"

# Audit assignment
az policy assignment create \
	--sku standard \
	--name $assignment_name \
	--scope $resource_group_id \
	--policy $definition_name \
	--params "{ \"throughputMax\": \"200\", \"effect\": \"audit\" }"
