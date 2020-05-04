#!/bin/bash

# Gets Azure Cosmos DB Resource Provider Aliases that can be used in a custom policy definition

subscription_id="$(az account show -o tsv --query "id")"

az provider show --namespace Microsoft.DocumentDB --expand "resourceTypes/aliases" --query "resourceTypes[].aliases[].name"

az graph query -q "Resources | where type=~'microsoft.DocumentDB' | limit 1 | project aliases" --subscriptions $subscription_id
