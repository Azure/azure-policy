# Add or replace a tag on resources

Adds or replaces the specified tag and value when any resource is created or updated. Existing resources can be remediated by triggering a remediation task. Does not modify tags on resource groups.

See https://aka.ms/modifydoc for more details about the modify effect and remediating modify policies.

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FTags%2Fadd-replace-tag%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "add-replace-tag" -DisplayName "Add or replace a tag on resources" -description "Adds or replaces the specified tag and value when any resource is created or updated. Existing resources can be remediated by triggering a remediation task. Does not modify tags on resource groups." -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Tags/add-replace-tag/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Tags/add-replace-tag/azurepolicy.parameters.json' -Mode Indexed
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope>  -tagName <tagName> -tagValue <tagValue> -PolicyDefinition $definition
$assignment 
````



## Try with CLI

````cli

az policy definition create --name 'add-replace-tag' --display-name 'Add or replace a tag on resources' --description 'Adds or replaces the specified tag and value when any resource is created or updated. Existing resources can be remediated by triggering a remediation task. Does not modify tags on resource groups.' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Tags/add-replace-tag/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Tags/add-replace-tag/azurepolicy.parameters.json' --mode Indexed

az policy assignment create --name <assignmentname> --scope <scope> --policy "add-replace-tag" --params "{'tagName':{'value': 'myTag'}, 'tagValue':{'value': 'myValue'}}"

````
