# Enforce a Route Table on every subnet

This policy enforces every subnet to be associated to a route table. The route table may target anything (NVA, Azure Firewall, etc.).

## Azure Policy Docs

See more information and a complete walk-through of using this sample on
[docs.microsoft.com](https://docs.microsoft.com/azure/azure-policy/scripts/enforce-firewall-route-table-on-subnet).

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/?feature.customportal=false&microsoft_azure_policy=true&microsoft_azure_policy_policyinsights=true&feature.microsoft_azure_security_policy=true&microsoft_azure_marketplace_policy=true#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FNetwork%2Fenforce-firewall-route-table-on-subnet%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzureRmPolicyDefinition -Name "enforce-firewallroutetable-on-subnet" -DisplayName "Azure Firewall Route table of every subnet" -description "This policy enforces a specific Route Table on every subnet." -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Network/enforce-firewall-route-table-on-subnet/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Network/enforce-firewall-route-table-on-subnet/azurepolicy.parameters.json' -Mode All
$definition
$assignment = New-AzureRMPolicyAssignment -Name <assignmentname> -Scope <scope> -PolicyDefinition $definition -rtId <routetable>
$assignment 
````



## Try with CLI

````cli

az policy definition create --name 'enforce-firewall-route-table-on-subnet' --display-name 'Route table of every subnet' --description 'This policy enforces a specific Route Table on every subnet.' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Network/enforce-firewall-route-table-on-subnet/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Network/enforce-firewall-route-table-on-subnet/azurepolicy.parameters.json' --mode All

az policy assignment create --name <assignmentname> --scope <scope> --policy "enforce-firewall-route-table-on-subnet" --rtId <routetable>

````
