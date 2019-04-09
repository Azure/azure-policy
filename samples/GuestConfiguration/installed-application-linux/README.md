# Audit Linux VMs that do not have the specified applications installed

This initiative uses [Azure Policy Guest Configuration](https://docs.microsoft.com/governance/policy/concepts/guest-configuration)
to audit if applications aren't installed in Linux virtual machines.

Initiative ID: `/providers/Microsoft.Authorization/policySetDefinitions/c937dcb4-4398-4b39-8d63-4a6be432252e`

Included policy definitions:

- audit:
  - ID: `/providers/Microsoft.Authorization/policyDefinitions/fee5cb2b-9d9b-410e-afe3-2902d90d0004`
  - Source: [policy definition](./audit/)
- deployIfNotExists
  - ID: `/providers/Microsoft.Authorization/policyDefinitions/4d1c04de-2172-403f-901b-90608c35c721`
  - Source: [policy definition](./deployIfNotExists/)

## Azure Policy Docs

See more information and a complete explanation of using this sample on
[docs.microsoft.com](https://docs.microsoft.com/azure/governance/policy/samples/guestconfiguration-installed-application-linux).

## Try with Azure portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/?#blade/Microsoft_Azure_Policy/CreatePolicySetDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FGuestConfiguration%2Finstalled-application-linux%2Fazurepolicyset.json)
[![Deploy to Azure Gov](https://docs.microsoft.com/azure/governance/policy/media/deploy/deployGovbutton.png)](https://portal.azure.us/?#blade/Microsoft_Azure_Policy/CreatePolicySetDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FGuestConfiguration%2Finstalled-application-linux%2Fazurepolicyset.json)

Using these buttons to deploy via the Portal creates a copy of the initiative that includes the
built-in policies for both **audit** and **deployIfNotExists**.

## Try with Azure PowerShell

```powershell
# Create the policy initiative (Subscription scope)
$initDef = New-AzPolicySetDefinition -Name 'guestconfig-installed-application-linux' -DisplayName 'GuestConfig - Audit if specified applications are not installed inside Linux VMs' -description 'This initiative will both deploy the policy requirements and audit that the specified application is installed inside Linux virtual machines.' -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/GuestConfiguration/installed-application-linux/azurepolicyset.definitions.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/GuestConfiguration/installed-application-linux/azurepolicyset.parameters.json' -Mode All

# Set the scope to a resource group; may also be a resource, subscription, or management group
$scope = Get-AzResourceGroup -Name 'YourResourceGroup'

# Set the initiative parameter (JSON format)
$initParam = '{ "installedApplication": { "value": "python; powershell" } }'

# Create the initiative assignment
$assignment = New-AzPolicyAssignment -Name 'guestconfig-installed-application-linux-assignment' -DisplayName 'GuestConfig - Python and PowerShell apps on Linux' -Scope $scope.ResourceID -PolicySetDefinition $initDef -PolicyParameter $initParam -AssignIdentity -Location 'westus2'

# Get the system-assigned managed identity created by the assignment with -AssignIdentity
$saIdentity = $assignment.Identity.principalId

# Give the system-assigned managed identity the 'Contributor' role on the scope (needed by deployIfNotExists)
$roleAssignment = New-AzRoleAssignment -ObjectId $saIdentity -Scope $scope.ResourceId -RoleDefinitionName 'Contributor'
```

## Try with Azure CLI

```cli
# Create the policy initiative (Subscription scope)
initdef=$(az policy set-definition create --name 'guestconfig-installed-application-linux' --display-name 'GuestConfig - Audit if specified applications are not installed inside Linux VMs' --description 'This initiative will both deploy the policy requirements and audit that the specified application is installed inside Linux virtual machines.' --definitions 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/GuestConfiguration/installed-application-linux/azurepolicyset.definitions.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/GuestConfiguration/installed-application-linux/azurepolicyset.parameters.json' --mode All)

# Set the scope to a resource group; may also be a subscription or management group
scope=$(az group show --name 'YourResourceGroup')

# Set the initiative parameter (JSON format)
initparam='{ "installedApplication": { "value": "python; powershell" } }'

# Create the initiative assignment and grant the created managed identity the 'Contributor' role on the resource group
assignment=$(az policy assignment create --name 'guestconfig-installed-application-linux-assignment' --display-name 'GuestConfig - Python and PowerShell apps on Linux' --scope `echo $scope | jq '.id' -r` --policy `echo $initdef | jq '.name' -r`) --assign-identity --identity-scope `echo $scope | jq '.id' -r` --role 'Contributor' --location 'westus2'
```