# API Connection Blacklist

This policy allows for blacklisting of specific API connections for Microsoft Flow, PowerApps and Logic Apps.

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FAPI-Connections%2Fapi-connection-blacklist%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "api-connection-blacklist" -DisplayName "Blacklisted Connector" -description "This policy allows for blacklisting of specific API connections for Microsoft Flow, PowerApps and Logic Apps." -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/API-Connections/api-connection-blacklist/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/API-Connections/api-connection-blacklist/azurepolicy.parameters.json' -Mode All
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope>  -roleDefinitionIds <Approved Role Definitions> -PolicyDefinition $definition
$assignment 
````



## Try with CLI

````cli

az policy definition create --name 'allowed-role-definitions' --display-name 'Allowed Role Definitions' --description 'This policy defines a white list of role deffnitions that can be used in IAM' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/API-Connections/api-connection-blacklist/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/API-Connections/api-connection-blacklist/azurepolicy.parameters.json' --mode All

az policy assignment create --name <assignmentname> --scope <scope> --policy "allowed-role-definitions" 

````
