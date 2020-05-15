$rules_url = "https://raw.githubusercontent.com/Azure/azure-policy/master/samples/CosmosDB/audit-cosmosdb-throughput/azurepolicy.rules.json"
$params_url = "https://raw.githubusercontent.com/Azure/azure-policy/master/samples/CosmosDB/audit-cosmosdb-throughput/azurepolicy.parameters.json"

New-AzPolicyDefinition `
	-Name "audit-cosmosdb-throughput" `
	-DisplayName "Audit Cosmos DB Throughput Exceeding Max" `
	-Description "Audit Cosmos DB Throughput Exceeding Max" `
	-Policy $rules_url `
	-Parameter $params_url `
	-Mode All
