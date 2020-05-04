# Variables
$resource_group_name = "my-resource-group-name"
$definition_name = "audit-cosmosdb-throughput"
$assignment_name = "audit-cosmosdb-throughput-$resource_group_name"
$display_name = "Audit Cosmos DB Throughput in Resource Group $resource_group_name"
$max_rus = 400

# Get the resource group ID so we can set it as policy assignment audit scope
$resource_group_id = (Get-AzResourceGroup -Name $resource_group_name).ResourceId

# Get the policy definition for input to policy assignment
$definition = Get-AzPolicyDefinition -Name $definition_name

# Prepare parameter input object
$parameter = @{'throughputMax' = $max_rus}

# Assign policy
New-AzPolicyAssignment `
	-Name $assignment_name `
	-DisplayName $display_name `
	-Scope $resource_group_id `
	-PolicyDefinition $definition `
	-PolicyParameterObject $parameter
