$custom_policy_definition_name = "My Custom Policy Definition Name"
$display_name = "My Custom Policy Definition Display Name"
$description = "My Custom Policy Definition Description"
$rules_url = "my-url-to/azurepolicy.rules.json"
$params_url = "my-url-to/azurepolicy.parameters.json"

New-AzPolicyDefinition `
	-Name $custom_policy_definition_name `
	-Metadata '{"category":"Cosmos DB"}' `
	-DisplayName $display_name `
	-Description $description `
	-Policy $rules_url `
	-Parameter $params_url `
	-Mode All
