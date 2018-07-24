# Only Allow public IP in specific subnets

Only allow public IP to be used in specific subnets

The subnetIds parameter must be provided with a list of subnets in format of resource ID (e.g /subscriptions/{subscription_id}/resourcegroups/{resource_group)/providers/microsoft.network/virtualnetworks/{vnet}/subnets/{subnet-name})

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/?feature.customportal=false&microsoft_azure_policy=true&microsoft_azure_policy_policyinsights=true&feature.microsoft_azure_security_policy=true&microsoft_azure_marketplace_policy=true#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FNetwork%2Fno-public-ip-except-for-one-subnet%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzureRmPolicyDefinition -Name "no-public-ip-except-for-one-subnet" -DisplayName "Only Allow public IP in specific subnets" -description "Only allow public IP to be used in specific subnets" -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Network/no-public-ip-except-for-one-subnet/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Network/no-public-ip-except-for-one-subnet/azurepolicy.parameters.json' -Mode All
$definition
$assignment = New-AzureRMPolicyAssignment -Name <assignmentname> -Scope <scope>  -subnetIds <List of Subnets you can use public IP> -PolicyDefinition $definition
$assignment 
````



## Try with CLI

````cli

az policy definition create --name 'no-public-ip-except-for-one-subnet' --display-name 'Only Allow public IP in specific subnets' --description 'Only allow public IP to be used in specific subnets' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Network/no-public-ip-except-for-one-subnet/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Network/no-public-ip-except-for-one-subnet/azurepolicy.parameters.json' --mode All

az policy assignment create --name <assignmentname> --scope <scope> --policy "no-public-ip-except-for-one-subnet" 

````
