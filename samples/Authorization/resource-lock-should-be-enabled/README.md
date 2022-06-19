# Content
With this policy: any resource that has the tag key *LockLevel* with the value *CanNotDelete* means authorized users can read and modify the resource, but they can’t delete it.

# Lock resources

See more information and a complete walk-through in the following Blog post [Compliance and delegation of Azure Locks through Azure Policy](https://medium.com/microsoftazure/compliance-and-delegation-of-azure-master-through-azure-policy-9f464d40faee).


Before implementing Azure Locks make sure you have read the following documentation [Considerations before applying your locks](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/lock-resources?tabs=json&WT.mc_id=AZ-MVP-5003548#considerations-before-applying-your-locks).

## Try with Azure portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FAuthorization%2Fresource-lock-should-be-enabled%2Fazurepolicy.json)

## Try with Azure PowerShell

````powershell
# Create the Policy Definition (Subscription scope)
$definition = New-AzPolicyDefinition -Name 'resource-lock-should-be-enabled' -DisplayName 'Resource Lock should be enabled' -description 'With this policy: any resource that has the tag key LockLevel with the value CanNotDelete means authorized users can read and modify the resource, but they can t delete it.' -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Authorization/resource-lock-should-be-enabled/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Authorization/resource-lock-should-be-enabled/azurepolicy.parameters.json' -Mode Indexed

# Set the scope to a resource group; may also be a subscription or management group
$scope = Get-AzResourceGroup -Name 'YourResourceGroup'

# Create the Policy Assignment
$assignment = New-AzPolicyAssignment -Name 'resource-lock-should-be-enabled-assignment' -DisplayName 'Resource Lock should be enabled - Assignment' -Scope $scope.ResourceId -PolicyDefinition $definition -IdentityType "SystemAssigned" -Location $scope.Location

# Assign the remediation role
New-AzRoleAssignment -Scope $scope.ResourceId -ObjectId $assignment.Identity.PrincipalId -RoleDefinitionId $definition.Properties.PolicyRule.then.details.roleDefinitionIds[0].split("/")[-1]

````

## Try with Azure CLI

```cli
# Create the Policy Definition (Subscription scope)
definition=$(az policy definition create --name 'resource-lock-should-be-enabled' --display-name 'Resource Lock should be enabled' --description 'With this policy: any resource that has the tag key LockLevel with the value CanNotDelete means authorized users can read and modify the resource, but they can t delete it.' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Authorization/resource-lock-should-be-enabled/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Authorization/resource-lock-should-be-enabled/azurepolicy.parameters.json' --mode Indexed)

# Set the scope to a resource group; may also be a subscription or management group
scope=$(az group show --name 'YourResourceGroup')

# Create the Policy Assignment
assignment=$(az policy assignment create --name 'resource-lock-should-be-enabled-assignment' --display-name 'Resource Lock should be enabled Assignment' --mi-system-assigned --location eastus --role Owner --identity-scope `echo $scope | jq '.id' -r` --policy `echo $definition | jq '.name' -r`)
```