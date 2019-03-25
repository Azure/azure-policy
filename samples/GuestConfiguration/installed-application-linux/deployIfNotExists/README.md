# Deploy requirements to audit Linux VMs that do not have the specified applications installed

This policy definition uses [Azure Policy Guest
Configuration](https://docs.microsoft.com/governance/policy/concepts/guest-configuration) to ensures
that the requirements are deployed to audit if a VM is missing specified applications that must be
installed. The requirements include a Guest Configuration assignment, a managed identity, and the
Guest Configuration extension. It's part of a policy initiative that deploys both the **audit** and
**deployIfNotExists** policy definitions needed by Guest Configuration. Read about the initiative
definition [here](../README.md).

## Azure Policy Docs

See more information and a full explanation of getting started with the full initiative sample on
[docs.microsoft.com](https://docs.microsoft.com/azure/governance/policy/samples/guestconfiguration-installed-application-linux).

## Try with Azure portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/?#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FGuestConfiguration%2Finstalled-application-linux%2FdeployIfNotExists%2Fazurepolicy.json)
[![Deploy to Azure Gov](https://docs.microsoft.com/azure/governance/policy/media/deploy/deployGovbutton.png)](https://portal.azure.us/?#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FGuestConfiguration%2Finstalled-application-linux%2FdeployIfNotExists%2Fazurepolicy.json)

Using these buttons to deploy via the Portal creates a copy of the **deployIfNotExists** policy
definition. Without the paired **audit** policy definition, the Guest Configuration
won't work correctly.

## Try with Azure PowerShell

```powershell
# Create the policy definition (Subscription scope)
$definition = New-AzPolicyDefinition -Name 'guestconfig-installed-application-linux-deployIfNotExists' -DisplayName 'GuestConfig - Deploy requirements to audit Linux VMs that do not have the specified applications installed' -description 'This initiative deploys the policy requirements and audits Linux virtual machines that do not have the specified applications installed.' -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/GuestConfiguration/installed-application-linux/deployIfNotExists/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/GuestConfiguration/installed-application-linux/deployIfNotExists/azurepolicy.parameters.json' -Mode All

# Set the scope to a resource group; may also be a resource, subscription, or management group
$scope = Get-AzResourceGroup -Name 'YourResourceGroup'

# Set the definition parameter (JSON format)
$policyParam  = '{ "installedApplication": { "value": "python; powershell" } }'

# Create the policy assignment
$assignment = New-AzPolicyAssignment -Name 'guestconfig-installed-application-linux-deployIfNotExists-assignment' -DisplayName 'GuestConfig - Deploy requirements to audit Linux VMs that do not have the specified applications installed' -Scope $scope.ResourceID -PolicyDefinition $definition -PolicyParameter $policyParam -AssignIdentity -Location 'westus2'

# Get the system-assigned managed identity created by the assignment with -AssignIdentity
$saIdentity = $assignment.Identity.principalId

# Give the system-assigned managed identity the 'Contributor' role on the scope (needed by deployIfNotExists)
$roleAssignment = New-AzRoleAssignment -ObjectId $saIdentity -Scope $scope.ResourceId -RoleDefinitionName 'Contributor'
```

## Try with Azure CLI

```cli
# Create the policy definition (Subscription scope)
definition=$(az policy definition create --name 'guestconfig-installed-application-linux-deployIfNotExists' --display-name 'GuestConfig - Deploy requirements to audit Linux VMs that do not have the specified applications installed' --description 'This initiative deploys the policy requirements and audits Linux virtual machines that do not have the specified applications installed.' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/GuestConfiguration/installed-application-linux/deployIfNotExists/azurepolicy.rules.json'  --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/GuestConfiguration/installed-application-linux/deployIfNotExists/azurepolicy.parameters.json' --mode All)

# Set the scope to a resource group; may also be a resource, subscription, or management group
scope=$(az group show --name 'YourResourceGroup')

# Set the definition parameter (JSON format)
policyparam='{ "installedApplication": { "value": "python; powershell" } }'

# Create the policy assignment and grant the created managed identity the 'Contributor' role on the resource group
assignment=$(az policy assignment create --name 'guestconfig-installed-application-linux-deployIfNotExists-assignment' --display-name 'GuestConfig - Deploy requirements to audit Linux VMs that do not have the specified applications installed' --scope `echo $scope | jq '.id' -r` --policy `echo $definition | jq '.name' -r`) --assign-identity --identity-scope `echo $scope | jq '.id' -r` --role 'Contributor' --location 'westus2'
```