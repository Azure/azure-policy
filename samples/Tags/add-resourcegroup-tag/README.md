# Add a tag to resource groups

Adds the specified tag and value when any resource group missing this tag is created or updated. Existing resource groups can be remediated by triggering a remediation task. If the tag exists with a different value it will not be changed.

See https://aka.ms/modifydoc for more details about the modify effect and remediating modify policies.

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FTags%2Fadd-resourcegroup-tag%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "add-resourcegroup-tag" -DisplayName "Add a tag to resource groups" -description "Adds the specified tag and value when any resource group missing this tag is created or updated. Existing resource groups can be remediated by triggering a remediation task. If the tag exists with a different value it will not be changed." -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Tags/add-resourcegroup-tag/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Tags/add-resourcegroup-tag/azurepolicy.parameters.json' -Mode All
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope>  -tagName <tagName> -tagValue <tagValue> -PolicyDefinition $definition
$assignment 
````



## Try with CLI

````cli

az policy definition create --name 'add-resourcegroup-tag' --display-name 'Add a tag to resource groups' --description 'Adds the specified tag and value when any resource group missing this tag is created or updated. Existing resource groups can be remediated by triggering a remediation task. If the tag exists with a different value it will not be changed.' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Tags/add-resourcegroup-tag/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Tags/add-resourcegroup-tag/azurepolicy.parameters.json' --mode All

az policy assignment create --name <assignmentname> --scope <scope> --policy "add-resourcegroup-tag" --params "{'tagName':{'value': 'myTag'}, 'tagValue':{'value': 'myValue'}}"

````
