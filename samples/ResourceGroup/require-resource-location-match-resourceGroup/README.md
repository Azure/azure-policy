# Require Resource Location to match Resource Group

Denies deployment of resource to Resource Group if location does not match that of the Resource Group. This is useful to prevent accidental misconfiguration leading to increased cost and latency.

## Try in the Azure Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FResourceGroup%2Frequire-resource-location-match-resourceGroup%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "require-resource-location-match-resourceGroup" -DisplayName "Require Resource Location to match Resource Group" -description "Denies deployment of resource to Resource Group if location does not match that of the Resource Group. This is useful to prevent accidental misconfiguration leading to increased cost and latency." -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/ResourceGroup/require-resource-location-match-resourceGroup/azurepolicy.rules.json' -Mode Indexed
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope> -PolicyDefinition $definition
$assignment
````

## Try with CLI

````cli
az policy definition create --name 'require-resource-location-match-resourceGroup' --display-name 'Require Resource Location to match Resource Group' --description 'Denies deployment of resource to Resource Group if location does not match that of the Resource Group. This is useful to prevent accidental misconfiguration leading to increased cost and latency.' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/ResourceGroup/require-resource-location-match-resourceGroup/azurepolicy.rules.json' --mode Indexed

az policy assignment create --name <assignmentname> --scope <scope> --policy "require-resource-location-match-resourceGroup"
````