# [Preview]: Deploy network watcher when virtual networks are created

This policy creates a network watcher resource in regions with virtual networks. You need to ensure existence of a resource group named networkWatcherRG, which will be used to deploy network watcher instances.

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2Fbuilt-in-policy%2Fdeploy-network-watcher-in-vnet-regions%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "deploy-network-watcher-in-vnet-regions" -DisplayName "[Preview]: Deploy network watcher when virtual networks are created" -description "This policy creates a network watcher resource in regions with virtual networks. You need to ensure existence of a resource group named networkWatcherRG, which will be used to deploy network watcher instances." -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/built-in-policy/deploy-network-watcher-in-vnet-regions/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/built-in-policy/deploy-network-watcher-in-vnet-regions/azurepolicy.parameters.json' -Mode All
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope>  -PolicyDefinition $definition
$assignment 
````



## Try with CLI

````cli

az policy definition create --name 'deploy-network-watcher-in-vnet-regions' --display-name '[Preview]: Deploy network watcher when virtual networks are created' --description 'This policy creates a network watcher resource in regions with virtual networks. You need to ensure existence of a resource group named networkWatcherRG, which will be used to deploy network watcher instances.' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/built-in-policy/deploy-network-watcher-in-vnet-regions/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/built-in-policy/deploy-network-watcher-in-vnet-regions/azurepolicy.parameters.json' --mode All

az policy assignment create --name <assignmentname> --scope <scope> --policy "deploy-network-watcher-in-vnet-regions" 

````
