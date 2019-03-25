# Audit Linux VMs that do not have the specified applications installed

This policy definition uses [Azure Policy Guest
Configuration](https://docs.microsoft.com/governance/policy/concepts/guest-configuration) to audit
if specified applications aren't installed in Linux virtual machines. It's part of a policy
initiative that deploys both the **audit** and **deployIfNotExists** policy definitions needed by
Guest Configuration. Read about the initiative definition [here](../README.md).

## Azure Policy Docs

See more information and a full explanation of getting started with the full initiative sample on
[docs.microsoft.com](https://docs.microsoft.com/azure/governance/policy/samples/guestconfiguration-installed-application-linux).

## Try with Azure portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/?#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FGuestConfiguration%2Finstalled-application-linux%2Faudit%2Fazurepolicy.json)
[![Deploy to Azure Gov](https://docs.microsoft.com/azure/governance/policy/media/deploy/deployGovbutton.png)](https://portal.azure.us/?#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FGuestConfiguration%2Finstalled-application-linux%2Faudit%2Fazurepolicy.json)

Using these buttons to deploy via the Portal creates a copy of the **audit** policy definition.
Without the paired **deployIfNotExists** policy definition, the Guest Configuration won't work
correctly.

## Try with Azure PowerShell

```powershell
# Create the policy definition (Subscription scope)
$definition = New-AzPolicyDefinition -Name 'guestconfig-installed-application-linux-audit' -DisplayName 'GuestConfig - Audit Linux VMs that do not have the specified applications installed' -description 'This policy audits Linux virtual machines that do not have the specified applications installed. This policy should only be used along with its corresponding deploy policy in an initiative/policy set.' -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/GuestConfiguration/installed-application-linux/audit/azurepolicy.rules.json' -Mode All

# Set the scope to a resource group; may also be a resource, subscription, or management group
$scope = Get-AzResourceGroup -Name 'YourResourceGroup'

# Create the policy assignment
$assignment = New-AzPolicyAssignment -Name 'guestconfig-installed-application-linux-audit-assignment' -DisplayName 'GuestConfig - Python and PowerShell apps on Linux' -Scope $scope.ResourceID -PolicyDefinition $definition
```

## Try with Azure CLI

```cli
# Create the policy definition (Subscription scope)
definition=$(az policy definition create --name 'guestconfig-installed-application-linux-audit' --display-name 'GuestConfig - Audit Linux VMs that do not have the specified applications installed' --description 'This policy audits Linux virtual machines that do not have the specified applications installed. This policy should only be used along with its corresponding deploy policy in an initiative/policy set.' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/GuestConfiguration/installed-application-linux/audit/azurepolicy.rules.json' --mode All)

# Set the scope to a resource group; may also be a resource, subscription, or management group
scope=$(az group show --name 'YourResourceGroup')

# Create the policy assignment
assignment=$(az policy assignment create --name 'guestconfig-installed-application-linux-audit-assignment' --display-name 'GuestConfig - Python and PowerShell apps on Linux' --scope `echo $scope | jq '.id' -r` --policy `echo $definition | jq '.name' -r`)
```