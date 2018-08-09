# Enforce Azure Firewall Route Table on every subnet

This policy enforces every subnet to be associated to a route table. Technically, the route table may target anything (NVA or an instance of the Azure Firewall,...) but the idea here is to provide the route table associated to an instance of Azure Firewall as assignment parameter in order to let Azure Firewall govern the outbound traffic of all the subnets included in a given VNET or Subscription.


## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/?feature.customportal=false&microsoft_azure_policy=true&microsoft_azure_policy_policyinsights=true&feature.microsoft_azure_security_policy=true&microsoft_azure_marketplace_policy=true#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FNetwork%2Faudit-network-watcher-existence%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzureRmPolicyDefinition -Name "enforce-firewallroutetable-on-subnet" -DisplayName "Azure Firewall Route table of every subnet" -description "This policy enforces a specific Route Table on every subnet." -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Network/enforce-firewall-route-table-on-subnet/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Network/enforce-firewall-route-table-on-subnet/azurepolicy.parameters.json' -Mode All
$definition
$assignment = New-AzureRMPolicyAssignment -Name <assignmentname> -Scope <scope> -PolicyDefinition $definition
$assignment 
````



## Try with CLI

````cli

az policy definition create --name 'enforce-firewallroutetable-on-subnet' --display-name 'Azure Firewall Route table of every subnet' --description 'This policy enforces a specific Route Table on every subnet.' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Network/enforce-firewall-route-table-on-subnet/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Network/enforce-firewall-route-table-on-subnet/azurepolicy.parameters.json' --mode All

az policy assignment create --name <assignmentname> --scope <scope> --policy "audit-network-watcher-existence" 

````
