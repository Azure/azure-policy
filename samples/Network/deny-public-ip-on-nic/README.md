# Deny's the ability to add a public IP to a virtual network interface.

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FNetwork%2Fdeny-public-ip-on-nic%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "deny-public-ip-on-nic" -DisplayName "Deny adding public IP Address to a virtual network interface" -description "Deny the ability to add a public IP Address to a virtual network interface." -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Network/deny-nsg-inbound-allow-all/azurepolicy.rules.json' -Mode All
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope> -PolicyDefinition $definition
$assignment 
````

## Try with CLI

````cli

az policy definition create --name 'deny-nsg-inbound-allow-all' --display-name 'Deny adding public IP Address to a virtual network interface' --description 'Deny the ability to add a public IP Address to a virtual network interface.' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Network/deny-public-ip-on-nic/azurepolicy.rules.json' --mode All

az policy assignment create --name <assignmentname> --scope <scope> --policy "deny-public-ip-on-nic" 

````


