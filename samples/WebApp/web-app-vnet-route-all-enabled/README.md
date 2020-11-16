# Enforce Web App VNet route all

This policy ensures that all traffic originating from a web app is routed through Regional VNet integration

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FWebApp%2Fweb-app-vnet-route-all-enabled%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "web-app-vnet-route-all-enabled" -DisplayName "Enforce Web App VNet route all" -description "This policy ensures that all traffic originating from a web app is routed through Regional VNet integration" -Policy 'https://raw.githubusercontent.com/DanielLarsenNZ/azure-policy/master/samples/WebApp/web-app-vnet-route-all-enabled/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/DanielLarsenNZ/azure-policy/master/samples/WebApp/web-app-vnet-route-all-enabled/azurepolicy.parameters.json' -Mode Indexed
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope> -PolicyDefinition $definition
$assignment
````

## Try with CLI

````cli

az policy definition create --name 'web-app-vnet-route-all-enabled' --display-name 'Enforce Web App VNet route all' --description 'This policy ensures that all traffic originating from a web app is routed through Regional VNet integration' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/WebApp/web-app-vnet-route-all-enabled/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/WebApp/web-app-vnet-route-all-enabled/azurepolicy.parameters.json' --mode Indexed

az policy assignment create --name <assignmentname> --scope <scope> --policy "web-app-vnet-route-all-enabled"

````
