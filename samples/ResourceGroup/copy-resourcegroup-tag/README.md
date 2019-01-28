# Copy resource group tag to resource

Copy a specific tag from the resource group to the resource.  For example, a tag named *example* on the resource group will be copied to the resources.  Change the word *example* in the policy rule to change the name of the tag copied to a resource.

## Try on Azure Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FResourceGroup%2Fcopy-resourcegroup-tag%2Fazurepolicy.json)

## Try with Azure PowerShell

````powershell
# Create the Policy Definition
$definition = New-AzPolicyDefinition -Name "copy-resourcegroup-tag" -DisplayName "Copy resource group tag to resource" -description "Copy a specific tag from the resource group to the resource.  For example, a tag named example on the resource group will be copied to the resources.  Change the word example in the policy rule to change the name of the tag copied to a resource." -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/ResourceGroup/copy-resourcegroup-tag/azurepolicy.rules.json' -Mode Indexed

# Show Definititon
$definition

# Create the Policy Assignment
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope> -PolicyDefinition $definition

# Show Assignment
$assignment 
````

## Try with Azure CLI

````cli
# Create the Policy Definition
az policy definition create --name 'copy-resourcegroup-tag' --display-name 'Copy resource group tag to resource' --description 'Copy a specific tag from the resource group to the resource.  For example, a tag named example on the resource group will be copied to the resources.  Change the word example in the policy rule to change the name of the tag copied to a resource.' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/ResourceGroup/copy-resourcegroup-tag/azurepolicy.rules.json' --mode Indexed

# Create the Policy Assignment
az policy assignment create --name <assignmentname> --scope <scope> --policy "copy-resourcegroup-tag" 

````
