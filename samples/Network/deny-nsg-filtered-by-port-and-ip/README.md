# Denies NSG rule additions/updates that allow all inbound traffic to designed ports from ips not in white list

Denies the addition/update of  a single network security group rule that allow all inbound traffic to designed ports from ips not in white list. To block the creation of NSG, then use another policy(https://github.com/Azure/Community-Policy/blob/master/Policies/Network/block-NSG-creations-updates). 

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FNetwork%2Fdeny-nsg-filtered-by-port-and-ip%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "deny-nsg-filtered-by-port-and-ip" -DisplayName "Denies NSG rule changes that allow all inbound traffic to designed ports from ips not in white list" -description "Denies people from changing NSG rules that allow all inbound traffic to designed ports from ips not in white list" -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Network/deny-nsg-filtered-by-port-and-ip/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Network/deny-nsg-filtered-by-port-and-ip/azurepolicy.parameters.json' -Mode All
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope> -PolicyDefinition $definition
$assignment 
````

## Try with CLI

````cli

az policy definition create --name 'deny-nsg-filtered-by-port-and-ip --display-name 'Denies NSG rule changes that allow all inbound traffic to designed ports from ips not in white list' --description 'Denies people from changing NSG rules that allow all inbound traffic to designed ports from ips not in white list' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Network/deny-nsg-filtered-by-port-and-ip/azurepolicy.rules.json' --parameters 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Network/deny-nsg-filtered-by-port-and-ip/azurepolicy.parameters.json' --mode All

az policy assignment create --name <assignmentname> --scope <scope> --policy "deny-nsg-filtered-by-port-and-ip" 

````
