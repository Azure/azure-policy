#!/bin/bash

# Variables
resource_group_name="my-resource-group-name"
definition_name="my-custom-policy-definition-name"
assignment_name="my-policy-assignment-name"
display_name="My Custom Policy Definition Display Name"
parameter_value="MyParameterValue"

# Get the resource group ID so we can set it as policy assignment audit scope
# Scope can also be subscription or management group.
resource_group_id="$(az group show -n "$resource_group_name" -o tsv --query "id")"

# Assign policy
az policy assignment create \
	--sku standard \
	--name "$assignment_name" \
	--display-name "$display_name" \
	--scope "$resource_group_id" \
	--policy "$definition_name" \
	--params "{ \"myParameterName\": { \"type\": \"myParameterType\", \"value\": $parameter_value } }"
