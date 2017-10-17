# Ensure network watcher is created

This policy automatically creates a network watcher instance for virtual networks if one does not exist.

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/?feature.customportal=false&microsoft_azure_policy=true#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade)

## Try with PowerShell

````powershell
$definition = New-AzureRmPolicyDefinition -Name "network-watcher-in-vnet-regions" -DisplayName "Ensure network watcher is created" -description "This policy automatically creates a network watcher instance for virtual networks if one does not exist." -Policy 'https://raw.githubusercontent.com/Azure/azure-policy-samples/master/samples/Network/network-watcher-in-vnet-regions/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy-samples/master/samples/Network/network-watcher-in-vnet-regions/azurepolicy.parameters.json' -Mode All
$definition
$assignment = New-AzureRMPolicyAssignment -Name <assignmentname> -Scope <scope> -PolicyDefinition $definition
$assignment 
````



## Try with CLI

````cli

az policy definition create --name 'network-watcher-in-vnet-regions' --display-name 'Ensure network watcher is created' --description 'This policy automatically creates a network watcher instance for virtual networks if one does not exist.' --rules 'https://raw.githubusercontent.com/Azure/azure-policy-samples/master/samples/Network/network-watcher-in-vnet-regions/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy-samples/master/samples/Network/network-watcher-in-vnet-regions/azurepolicy.parameters.json' --mode All

az policy assignment create --name <assignmentname> --scope <scope> --policy "network-watcher-in-vnet-regions" 

````
