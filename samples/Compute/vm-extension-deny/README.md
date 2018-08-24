# Deny installation of VM extensions

Denies the installation of virtul machine extensions

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/?feature.customportal=false&microsoft_azure_policy=true&microsoft_azure_policy_policyinsights=true&feature.microsoft_azure_security_policy=true&microsoft_azure_marketplace_policy=true#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2Fcompute%2Fvm-extension-deny%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzureRmPolicyDefinition -Name "vm-extension-deny" -DisplayName "Deny installation of VM extensions" -description "Denies the installation of virtul machine extensions" -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/compute/vm-extension-deny/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/compute/vm-extension-deny/azurepolicy.parameters.json' -Mode All
$definition
$assignment = New-AzureRMPolicyAssignment -Name <assignmentname> -Scope <scope> -AllowedExtensions <AllowedExtensions> -PolicyDefinition $definition
$assignment 
````

## Try with CLI

````cli

az policy definition create --name 'vm-extension-deny' --display-name 'Deny installation of VM extensions' --description 'Denies the installation of virtul machine extensions' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/compute/vm-extension-deny/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/compute/vm-extension-deny/azurepolicy.parameters.json' --mode All

az policy assignment create --name <assignmentname> --scope <scope> -AllowedExtensions <AllowedExtensions> --policy "vm-extension-deny" 

````