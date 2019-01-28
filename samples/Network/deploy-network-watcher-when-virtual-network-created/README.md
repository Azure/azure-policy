# Deploy network watcher when virtual networks are created

This policy creates a network watcher resource in regions with virtual networks. You need to ensure existence of a resource group named networkWatcherRG, which will be used to deploy network watcher instances.

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FNetwork%2Fdeploy-network-watcher-when-virtual-network-created%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "deploy-network-watcher-when-virtual-network-created" -DisplayName "Deploy network watcher when virtual networks are created" -description "This policy creates a network watcher resource in regions with virtual networks. You need to ensure existence of a resource group named networkWatcherRG, which will be used to deploy network watcher instances." -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Network/deploy-network-watcher-when-virtual-network-created/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Network/deploy-network-watcher-when-virtual-network-created/azurepolicy.parameters.json' -Mode Indexed
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope> -PolicyDefinition $definition
$assignment 
````

## Try with CLI

````cli

az policy definition create --name 'deploy-network-watcher-when-virtual-network-created' --display-name 'Deploy network watcher when virtual networks are created' --description 'This policy creates a network watcher resource in regions with virtual networks. You need to ensure existence of a resource group named networkWatcherRG, which will be used to deploy network watcher instances.' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Network/deploy-network-watcher-when-virtual-network-created/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Network/deploy-network-watcher-when-virtual-network-created/azurepolicy.parameters.json' --mode Indexed

az policy assignment create --name <assignmentname> --scope <scope> --policy "deploy-network-watcher-when-virtual-network-created" 

````
