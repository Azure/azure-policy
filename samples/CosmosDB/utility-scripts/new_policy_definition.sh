#!/bin/bash

custom_policy_definition_name="My Custom Policy Definition Name"
display_name="My Custom Policy Definition Display Name"
description="My Custom Policy Definition Description"
rules_url="my-url-to/azurepolicy.rules.json"
params_url="my-url-to/azurepolicy.parameters.json"

az policy definition create \
	--name "$custom_policy_definition_name" \
	--metadata "\"category\"=\"Cosmos DB\"" \
	--display-name "$display_name" \
	--description "$description" \
	--rules "$rules_url" \
	--params "$params_url" \
	--mode All
