#!/bin/bash

subscription_id="$(az account show -o tsv --query "id")"

az provider show --namespace Microsoft.DocumentDB --expand "resourceTypes/aliases" --query "resourceTypes[].aliases[].name"

az graph query -q "Resources | where type=~'microsoft.DocumentDB' | limit 1 | project aliases" --subscriptions $subscription_id
