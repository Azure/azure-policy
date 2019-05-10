# Copy resource group tag to resource

Copy a tag specified in the parameter value from the resource group to the resource.  For example, a tag named costCenter on the resource group will be copied to the resources. Provide the actual tag name in tagName parameter at time of policy assignment.

## Try on Azure Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FResourceGroup%2Fcopy-resourcegroup-tag%2Fazurepolicy.json)

## Try with Azure PowerShell

````powershell
# Create the Policy Definition
$definition = New-AzPolicyDefinition -Name "copy-resourcegroup-tag" -DisplayName "Copy resource group tag to resource" -description "Copy a tag specified in the parameter value from the resource group to the resource.  For example, a tag named costCenter on the resource group will be copied to the resources. Provide the actual tag name in tagName parameter at time of policy assignment." -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/ResourceGroup/copy-resourcegroup-tag/azurepolicy.rules.json' -Mode Indexed

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
az policy definition create --name 'copy-resourcegroup-tag' --display-name 'Copy resource group tag to resource' --description 'Copy a tag specified in the parameter value from the resource group to the resource.  For example, a tag named costCenter on the resource group will be copied to the resources. Provide the actual tag name in tagName parameter at time of policy assignment.' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/ResourceGroup/copy-resourcegroup-tag/azurepolicy.rules.json' --mode Indexed

# Create the Policy Assignment
az policy assignment create --name 'copy-resourcegroup-tag' --scope <scope> --policy "copy-resourcegroup-tag" --params "{'tagName':{'value': 'costCenter'}}" 

````
