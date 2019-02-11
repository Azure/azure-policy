# Deploy extension to audit for installed applications in Linux VMs

This policy ensures that the requirements are deployed to audit a VM for applications that must be installed.  The requirements include a guest assignment, a managed service identity, and the guest configuration extension.

This policy requires another definition to also be deployed that audits the results published in Azure Resource Manager.  Please see the policy sample
[Audit for installed application - Linux](../audit-installed-application-linux\README.md).

## Azure Policy Docs

See more information and a complete walk-through of using this sample on
[docs.microsoft.com](https://docs.microsoft.com/azure/governance/policy/samples/deployextension-installed-application-linux).

## Try with Azure portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/?#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FGuestConfiguration%2Fdeployextension-installed-application-linux%2Fazurepolicy.json)
[![Deploy to Azure Gov](https://docs.microsoft.com/azure/governance/policy/media/deploy/deployGovbutton.png)](https://portal.azure.us/?#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FGuestConfiguration%2Fdeployextension-installed-application-linux%2Fazurepolicy.json)

## Try with Azure PowerShell

````powershell
# Create the Policy Definition (Subscription scope)
$definition = New-AzPolicyDefinition -Name 'deployextension-installed-application-linux' -DisplayName 'Deploy extension to audit for installed applications in Linux VMs' -description 'This audits whether applications are installed inside Linux VMs' -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/GuestConfiguration/deployextension-installed-application-linux/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/GuestConfiguration/deployextension-installed-application-linux/azurepolicy.parameters.json' -Mode Indexed

# Set the scope to a resource group; may also be a subscription or management group
$scope = Get-AzResourceGroup -Name 'YourResourceGroup'

# Set the Policy Parameter (JSON format)
$policyparam = '{ "ApplicationNames": { "value": [ "python,powershell" ] } }'

# Create the Policy Assignment
$assignment = New-AzPolicyAssignment -Name 'deployextension-installed-application-linux-assignment' -DisplayName 'Audit whether applications are installed inside Linux VMs Assignment' -Scope $scope.ResourceId -PolicyDefinition $definition -PolicyParameter $policyparam
````

## Try with Azure CLI

```cli
# Create the Policy Definition (Subscription scope)
definition=$(az policy definition create --name 'deployextension-installed-application-linux' --display-name 'Deploy extension to audit for installed applications in Linux VMs' --description 'This policy audits whether applications are installed inside Linux VMs' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/GuestConfiguration/deployextension-installed-application-linux/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/GuestConfiguration/deployextension-installed-application-linux/azurepolicy.parameters.json' --mode Indexed)

# Set the scope to a resource group; may also be a subscription or management group
scope=$(az group show --name 'YourResourceGroup')

# Set the Policy Parameter (JSON format)
policyparam='{ "ApplicationNames": { "value": [ "python,powershell" ] } }'

# Create the Policy Assignment
assignment=$(az policy assignment create --name 'deployextension-installed-application-linux-assignment' --display-name 'Audit whether applications are installed inside Linux VMs Assignment' --scope `echo $scope | jq '.id' -r` --policy `echo $definition | jq '.name' -r` --params "$policyparam")
```
