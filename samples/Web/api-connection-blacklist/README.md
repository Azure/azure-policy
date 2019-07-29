# API Connection Blacklist

This policy allows for blacklisting of specific API connections for Microsoft Flow, PowerApps and Logic Apps.

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FWeb%2Fapi-connection-blacklist%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "api-connection-blacklist" -DisplayName "API Connection Blacklist" -description "This policy allows for blacklisting of specific API connections for Microsoft Flow, PowerApps and Logic Apps." -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Web/api-connection-blacklist/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Web/api-connection-blacklist/azurepolicy.parameters.json' -Mode All
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope>  -connectionNames <blacklisted connection names> -PolicyDefinition $definition
$assignment 
````



## Try with CLI

````cli

az policy definition create --name 'api-connection-blacklist' --display-name 'API Connection Blacklist' --description 'This policy allows for blacklisting of specific API connections for Microsoft Flow, PowerApps and Logic Apps.' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Web/api-connection-blacklist/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Web/api-connection-blacklist/azurepolicy.parameters.json' --mode All

az policy assignment create --name <assignmentname> --scope <scope> --policy "api-connection-blacklist" 

````
