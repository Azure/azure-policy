# Allow only selected IPs for Event Hub firewall

This policy will restrict adding firewall IPs in event hub and allow only those IPs which are predefined in array of selected IPs.

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FEventHub%2Fallowed-event-hub-firewall-ip%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name 'allowed-event-hub-firewall' -DisplayName 'Allow IP for event hub firewall' -description 'List of IPs allowed for event hub firewall' -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/EventHub/allowed-event-hub-firewall-ip/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/EventHub/allowed-event-hub-firewall-ip/azurepolicy.parameters.json' -Mode All

# Set the scope to a resource group; may also be a subscription or management group
$scope = Get-AzResourceGroup -Name 'rg-eventhub'

# Set the Policy Parameter (JSON format)
$policyparam = '{ "allowedIps": { "value": [ "10.12.3.7", "22.8.1.5" ] } }'

# Create the Policy Assignment
$assignment = New-AzPolicyAssignment -Name 'allowed-event-hub-firewall-assignment' -DisplayName 'Allow IPs for event hub firewall Assignment' -Scope $scope.ResourceId -PolicyDefinition $definition -PolicyParameter $policyparam

````

## Try with CLI

````cli

# Create the Policy Definition (Subscription scope)
definition=$(az policy definition create --name 'allowed-event-hub-firewall' --display-name 'Allow IP for event hub firewall' --description 'List of IPs allowed for event hub firewall' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/EventHub/allowed-event-hub-firewall-ip/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/EventHub/allowed-event-hub-firewall-ip/azurepolicy.parameters.json' --mode All)

# Set the scope to a resource group; may also be a subscription 
scope=$(az group show --name 'rg-eventhub')

# Set the Policy Parameter (JSON format)
policyparam='{ "allowedIps": { "value": [ "10.12.3.7", "22.8.1.5" ]} }'

# Create the Policy Assignment
assignment=$(az policy assignment create --name 'allowed-event-hub-firewall' --display-name 'Allow IP for event hub firewall Assignment' --scope `echo $scope | jq '.id' -r` --policy `echo $definition | jq '.name' -r` --params "$policyparam")

````
