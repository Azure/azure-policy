# Audit diagnostic setting

Audit diagnostic setting for selected resource types

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/?feature.customportal=false&microsoft_azure_policy=true&microsoft_azure_policy_policyinsights=true&feature.microsoft_azure_security_policy=true&microsoft_azure_marketplace_policy=true#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2Fbuilt-in-policy%audit-diagnostic-setting%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzureRmPolicyDefinition -Name "audit-diagnostic-setting" -DisplayName "Audit diagnostic setting" -description "Audit diagnostic setting for selected resource types" -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/built-in-policy/audit-diagnostic-setting/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/built-in-policy/audit-diagnostic-setting/azurepolicy.parameters.json' -Mode All
$definition
$assignment = New-AzureRMPolicyAssignment -Name <assignmentname> -Scope <scope> -listOfResourceTypes <listOfResourceTypes> -PolicyDefinition $definition
$assignment 
````

## Try with CLI

````cli

az policy definition create --name 'audit-diagnostic-setting' --display-name 'Audit diagnostic setting' --description 'Audit diagnostic setting for selected resource types' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/built-in-policy/audit-diagnostic-setting/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/built-in-policy/audit-diagnostic-setting/azurepolicy.parameters.json' --mode All

az policy assignment create --name <assignmentname> --scope <scope> --listOfResourceTypes <listOfResourceTypes> --policy "audit-diagnostic-setting" 

````
