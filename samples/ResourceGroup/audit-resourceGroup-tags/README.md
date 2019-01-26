# Audit resource groups missing tags

Audit resource groups that doesn't have particular tag

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FResourceGroup%2Faudit-resourceGroup-tags%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "audit-resourceGroup-tags" -DisplayName "Audit resource groups missing tags" -description "Audit resource groups that doesn't have particular tag" -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/ResourceGroup/audit-resourceGroup-tags/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/ResourceGroup/audit-resourceGroup-tags/azurepolicy.parameters.json' -Mode All
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope>  -tagName <tagName> -PolicyDefinition $definition
$assignment 
````



## Try with CLI

````cli

az policy definition create --name 'audit-resourceGroup-tags' --display-name 'Audit resource groups missing tags' --description 'Audit resource groups that doesn't have particular tag' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/ResourceGroup/audit-resourceGroup-tags/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/ResourceGroup/audit-resourceGroup-tags/azurepolicy.parameters.json' --mode All

az policy assignment create --name <assignmentname> --scope <scope> --policy "audit-resourceGroup-tags" 

````
