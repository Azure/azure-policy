#!/bin/bash

resource_group_name="cosmos"
definition_name="audit-or-deny-cosmosdb-throughput"
audit_policy_name="cosmosdb-throughput-audit"
deny_policy_name="cosmosdb-throughput-deny"

resource_group_id="$(az group show -n "$resource_group_name" -o tsv --query "id")"

# Audit assignment
az policy assignment create \
	--sku standard \
	--name $audit_policy_name \
	--scope $resource_group_id \
	--policy $definition_name \
	--params "{ \"throughputMax\": \"200\", \"effect\": \"audit\" }"

# Deny assignment
az policy assignment create \
	--sku standard \
	--name $audit_policy_name \
	--scope $resource_group_id \
	--policy $definition_name \
	--params "{ \"throughputMax\": \"200\", \"effect\": \"deny\" }"
