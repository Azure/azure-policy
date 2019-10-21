# Append tag and its value from the resource group

When a resource which is missing the specified tag is created or updated, adds that tag with its value from the resource group to the resource. Does not modify the tags of resources created before this policy was applied until those resources are changed. New 'modify' effect policies are available that support remediation of tags on existing resources (see https://aka.ms/modifydoc).

A new remediable variant of this policy can be viewed [here](../../Tags/inherit-resourcegroup-tag-if-missing/).

In the example below, the tag named costCenter on the resource group will be copied to the resources (when they are updated). Provide the tag name in tagName parameter at time of policy assignment.
## Try on Azure Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FResourceGroup%2Fcopy-resourcegroup-tag%2Fazurepolicy.json)

## Try with Azure PowerShell

````powershell
# Create the Policy Definition
$definition = New-AzPolicyDefinition -Name "copy-resourcegroup-tag" -DisplayName "Append tag and its value from the resource group" -description "Appends the specified tag with its value from the resource group when any resource which is missing this tag is created or updated. Does not modify the tags of resources created before this policy was applied until those resources are changed. New 'modify' effect policies are available that support remediation of tags on existing resources (see https://aka.ms/modifydoc)." -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/ResourceGroup/copy-resourcegroup-tag/azurepolicy.rules.json' -Mode Indexed

# Show Definititon
$definition

# Create the Policy Assignment
$scope = Get-AzResourceGroup -Name 'YourResourceGroup'
$assignment = New-AzPolicyAssignment -Name "copy-resource-group-tag" -Scope $scope -PolicyDefinition $definition -tagName "CostCenter"

# Show Assignment
$assignment 
````

## Try with Azure CLI

````cli
# Create the Policy Definition
az policy definition create --name 'copy-resourcegroup-tag' --display-name 'Append tag and its value from the resource group' --description 'Appends the specified tag with its value from the resource group when any resource which is missing this tag is created or updated. Does not modify the tags of resources created before this policy was applied until those resources are changed. New 'modify' effect policies are available that support remediation of tags on existing resources (see https://aka.ms/modifydoc).' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/ResourceGroup/copy-resourcegroup-tag/azurepolicy.rules.json' --mode Indexed

# Create the Policy Assignment
az policy assignment create --name 'copy-resourcegroup-tag' --scope <scope> --policy "copy-resourcegroup-tag" --params "{'tagName':{'value': 'costCenter'}}" 

````
