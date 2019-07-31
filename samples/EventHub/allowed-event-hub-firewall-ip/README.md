# Allowed only selected IPs for Event hub firewall

This policy allows user to specify selected IPs for event hub firewall from specified array of IPs. You specify an array of predefined IPs for event hub firewall. 

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FEventHub%2Fallowed-event-hub-firewall-ip%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name 'allowed-event-hub-firewall' -DisplayName 'Allow IP for event hub firewall' -description 'List of IPs allowed for event hub firewall' -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/EventHub/allowed-event-hub-firewall-ip/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/EventHub/allowed-event-hub-firewall-ip/azurepolicy.parameters.json' -Mode All
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope> -PolicyDefinition $definition
$assignment 
````

## Try with CLI

````cli

az policy definition create --name 'allowed-event-hub-firewall' --display-name 'Allow IP for event hub firewall' --description 'List of IPs allowed for event hub firewall' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/EventHub/allowed-event-hub-firewall-ip/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/EventHub/allowed-event-hub-firewall-ip/azurepolicy.parameters.json' --mode Indexed

az policy assignment create --name <assignmentname> --scope <scope> --policy "'allowed-event-hub-firewall" 

````
