# Resource name contains resource group name

Require resources to contain the resource group's name

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/?feature.customportal=false&microsoft_azure_policy=true&microsoft_azure_policy_policyinsights=true&feature.microsoft_azure_security_policy=true&microsoft_azure_marketplace_policy=true#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FTextPatterns%contain-resource-group-name%2Fazurepolicy.json)

## Try with PowerShell

````powershell

$definition = New-AzureRmPolicyDefinition -Name "contain-resource-group-name" -DisplayName "Resource name contains resource group name" -description "Require resources to contain the resource group's name" -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/TextPatterns/contain-resource-group-name/azurepolicy.rules.json' -Mode ALL
$definition
$assignment = New-AzureRMPolicyAssignment -Name <assignmentname> -Scope <scope> -PolicyDefinition $definition
$assignment

````

## Try with CLI

````cli

az policy definition create --name 'contain-resource-group-name' --display-name 'Resource name contains resource group name
' --description 'Require resources to contain the resource group's name' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/TextPatterns/contain-resource-group-name/azurepolicy.rules.json' --mode ALL

 az policy assignment create --name <assignmentname> --scope <scope> --policy "contain-resource-group-name"

 ````
