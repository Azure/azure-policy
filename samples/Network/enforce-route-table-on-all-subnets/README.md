# Enforce a Route Table on every subnet

This policy enforces every subnet to be associated to a route table. The route table may target anything (NVA, Azure Firewall, etc.).

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FNetwork%2Fenforce-route-table-on-subnet%2Fazurepolicy.json)

[![Deploy to Azure Gov](https://docs.microsoft.com/azure/azure-policy/media/deploy/deployGovbutton.png)](https://portal.azure.us/?#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FNetwork%2Fenforce-route-table-on-subnet%2Fazurepolicy.json)


## Try with PowerShell

````powershell
# Create the Policy Definition (Subscription scope)
$definition = New-AzPolicyDefinition -Name 'enforce-route-table-on-subnet' -DisplayName 'Route table on every subnet' -description 'This policy enforces a specific Route Table on every subnet.' -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Network/enforce-route-table-on-subnet/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Network/enforce-route-table-on-subnet/azurepolicy.parameters.json' -Mode All


# Set the scope to a resource group; may also be a subscription or management group
$scope = Get-AzResourceGroup -Name 'YourResourceGroup'

# Set the Policy Parameter (JSON format)
$policyparam = '{ "rtId": "/subscriptions/<subscriptionId>/resourceGroups/YourResourceGroup/providers/Microsoft.Network/routeTables/YourTable"}'

# Create the Policy Assignment
$assignment = New-AzPolicyAssignment -Name 'enforce-route-table-on-subnet-assignment' -DisplayName 'Enforce a route table on subnet' -Scope $scope.ResourceId -PolicyDefinition $definition -PolicyParameter $policyparam
````

## Try with CLI

````cli
# Create the Policy Definition (Subscription scope)
definition=$(az policy definition create --name 'enforce-route-table-on-subnet' --display-name 'Route table on every subnet' --description 'This policy enforces a specific Route Table on every subnet.' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Network/enforce-route-table-on-subnet/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Network/enforce-route-table-on-subnet/azurepolicy.parameters.json' --mode All)

# Set the scope to a resource group; may also be a subscription or management group
scope=$(az group show --name 'YourResourceGroup')

# Set the Policy Parameter (JSON format)
policyparam='{ "rtId": "/subscriptions/<subscriptionId>/resourceGroups/YourResourceGroup/providers/Microsoft.Network/routeTables/YourTable" }'

# Create the Policy Assignment
assignment=$(az policy assignment create --name 'enforce-route-table-on-subnet-assignment' --display-name 'Route table on every subnet Assignment' --scope `echo $scope | jq '.id' -r` --policy `echo $definition | jq '.name' -r` --params "$policyparam")
````
