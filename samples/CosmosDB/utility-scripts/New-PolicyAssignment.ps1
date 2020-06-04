# Variables
$resource_group_name = "my-resource-group-name"
$definition_name = "my-custom-policy-definition-name"
$assignment_name = "my-policy-assignment-name"
$display_name = "My Custom Policy Definition Display Name"
$parameter_value = "MyParameterValue"

# Get the resource group ID so we can set it as policy assignment audit scope
# Scope can also be subscription or management group.
$resource_group_id = (Get-AzResourceGroup -Name $resource_group_name).ResourceId

# Get the policy definition for input to policy assignment
$definition = Get-AzPolicyDefinition -Name $definition_name

# Prepare parameter input object
$parameter = @{'myParameterName' = $parameter_value}

# Assign policy
New-AzPolicyAssignment `
	-Name $assignment_name `
	-DisplayName $display_name `
	-Scope $resource_group_id `
	-PolicyDefinition $definition `
	-PolicyParameterObject $parameter
