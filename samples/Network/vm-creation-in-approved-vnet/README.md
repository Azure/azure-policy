# Use approved subnet for VM network interfaces

This policy enforces VM network interfaces to use subnet

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/?feature.customportal=false&microsoft_azure_policy=true#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade)

## Try on PowerShell

````powershell
$definition = New-AzureRmPolicyDefinition -Name "vm-creation-in-approved-vnet" -DisplayName "Use approved subnet for VM network interfaces" -description "This policy enforces VM network interfaces to use subnet" -Policy 'https://raw.githubusercontent.com/Azure/azure-policy-samples/master/samples/Network/vm-creation-in-approved-vnet/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy-samples/master/samples/Network/vm-creation-in-approved-vnet/azurepolicy.parameters.json' -Mode All
$definition
$assignment = New-AzureRMPolicyAssignment -Name <assignmentname> -Scope <scope> -PolicyDefinition $definition
$assignment 
````



## Try with CLI

````cli

az policy definition create --name 'vm-creation-in-approved-vnet' --display-name 'Use approved subnet for VM network interfaces' --description 'This policy enforces VM network interfaces to use subnet' --rules 'https://raw.githubusercontent.com/Azure/azure-policy-samples/master/samples/Network/vm-creation-in-approved-vnet/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy-samples/master/samples/Network/vm-creation-in-approved-vnet/azurepolicy.parameters.json' --mode All

az policy assignment create --name <assignmentname> --scope <scope> --policy "vm-creation-in-approved-vnet" 

````
