# Audit that applications are installed inside Linux VMs

This policy audits applications installed in Linux virtual machines.

This policy requires another definition to also be deployed that loads requirements for performing audits inside virtual machines.  Please see the policy sample
[Deploy extension to audit for installed applications - Linux](../deployextension-installed-application-linux\README.md).

## Azure Policy Docs

See more information and a complete walk-through of using this sample on
[docs.microsoft.com](https://docs.microsoft.com/azure/governance/policy/samples/audit-installed-application-linux).

## Try with Azure portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/?#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FGuestConfiguration%2Faudit-installed-application-linux%2Fazurepolicy.json)
[![Deploy to Azure Gov](https://docs.microsoft.com/azure/governance/policy/media/deploy/deployGovbutton.png)](https://portal.azure.us/?#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FGuestConfiguration%2Faudit-installed-application-linux%2Fazurepolicy.json)

## Try with Azure PowerShell

````powershell
# Create the Policy Definition (Subscription scope)
$definition = New-AzPolicyDefinition -Name 'audit-installed-application-linux' -DisplayName 'Audit that applications are installed inside Linux VMs' -description 'This policy audits that applications are installed inside Linux VMs' -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/GuestConfiguration/audit-installed-application-linux/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/GuestConfiguration/audit-installed-application-linux/azurepolicy.parameters.json' -Mode All

# Set the scope to a resource group; may also be a subscription or management group
$scope = Get-AzResourceGroup -Name 'YourResourceGroup'

# Create the Policy Assignment
$assignment = New-AzPolicyAssignment -Name 'audit-installed-application-linux-assignment' -DisplayName 'Audit that an application is installed inside Linux VMs Assignment' -Scope $scope.ResourceId -PolicyDefinition $definition
````

## Try with Azure CLI

```cli
# Create the Policy Definition (Subscription scope)
definition=$(az policy definition create --name 'audit-installed-application-linux' --display-name 'Audit that applications are installed inside Linux VMs' --description 'This policy audits that applications are installed inside Linux VMs' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/GuestConfiguration/audit-installed-application-linux/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/GuestConfiguration/audit-installed-application-linux/azurepolicy.parameters.json' --mode All)

# Set the scope to a resource group; may also be a subscription or management group
scope=$(az group show --name 'YourResourceGroup')

# Create the Policy Assignment
assignment=$(az policy assignment create --name 'audit-installed-application-linux-assignment' --display-name 'Audit that an application is installed inside Linux VMs Assignment' --scope `echo $scope | jq '.id' -r` --policy `echo $definition | jq '.name' -r`)
```
