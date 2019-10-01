# Inherit a tag from the resource group

Adds or replaces the specified tag and value from the parent resource group when any resource is created or updated. Existing resources can be remediated by triggering a remediation task.

See https://aka.ms/modifydoc for more details about the modify effect and remediating modify policies.

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FTags%2Finherit-resourcegroup-tag%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "inherit-resourcegroup-tag" -DisplayName "Inherit a tag from the resource group" -description "Adds or replaces the specified tag and value from the parent resource group when any resource is created or updated. Existing resources can be remediated by triggering a remediation task." -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Tags/inherit-resourcegroup-tag/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Tags/inherit-resourcegroup-tag/azurepolicy.parameters.json' -Mode Indexed
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope>  -tagName <tagName> -PolicyDefinition $definition
$assignment 
````



## Try with CLI

````cli

az policy definition create --name 'inherit-resourcegroup-tag' --display-name 'Inherit a tag from the resource group' --description 'Adds or replaces the specified tag and value from the parent resource group when any resource is created or updated. Existing resources can be remediated by triggering a remediation task.' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Tags/inherit-resourcegroup-tag/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Tags/inherit-resourcegroup-tag/azurepolicy.parameters.json' --mode Indexed

az policy assignment create --name <assignmentname> --scope <scope> --policy "inherit-resourcegroup-tag" --params "{'tagName':{'value': 'myTag'}}"

````
