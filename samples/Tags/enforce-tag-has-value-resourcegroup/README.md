# Enforce tag has a value on a resource group

Enforces a required tag has a non empty value.

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2Fsamples%2FTags%2Fenforce-tag-has-value-resourcegroup%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "enforce-tag-has-value-resourcegroup" -DisplayName "Enforce tag has a value on a resource group" -description "Enforces a required tag has a non empty value." -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Tags/enforce-tag-has-value-resourcegroup/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Tags/enforce-tag-has-value-resourcegroup/azurepolicy.parameters.json' -Mode All
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope>  -tagName <tagName> -tagValue <tagValue> -PolicyDefinition $definition
$assignment 
````



## Try with CLI

````cli

az policy definition create --name 'enforce-tag-has-value-resourcegroup' --display-name 'Enforce tag has a value on a resource group' --description 'Enforces a required tag has a non empty value.' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Tags/enforce-tag-has-value-resourcegroup/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Tags/enforce-tag-has-value-resourcegroup/azurepolicy.parameters.json' --mode All

az policy assignment create --name <assignmentname> --scope <scope> --policy "enforce-tag-has-value-resourcegroup" 

````
