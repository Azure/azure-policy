# Resource name contains resource group name

Require resources to contain the resource group's name

## Try with PowerShell

````powershell

$definition = New-AzureRmPolicyDefinition -Name "contain-resource-group-name" -DisplayName "Resource name contains resource group name
" -description "Require resources to contain the resource group's name" -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/built-in-policy/contain-resource-group-name/azurepolicy.rules.json' -Mode ALL
$definition
$assignment = New-AzureRMPolicyAssignment -Name <assignmentname> -Scope <scope> -PolicyDefinition $definition
$assignment

````

## Try with CLI

````cli

az policy definition create --name 'contain-resource-group-name' --display-name 'Resource name contains resource group name
' --description 'Require resources to contain the resource group's name' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/built-in-policy/contain-resource-group-name/azurepolicy.rules.json' --mode ALL

 az policy assignment create --name <assignmentname> --scope <scope> --policy "contain-resource-group-name"

 ````