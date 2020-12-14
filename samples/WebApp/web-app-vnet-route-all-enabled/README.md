# Enforce Web App VNet route all

This policy ensures that all traffic originating from a web app is routed through Regional VNet integration

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FWebApp%2Fweb-app-vnet-route-all-enabled%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "audit-web-app-vnet-route-all-enabled" -DisplayName "Audit Web App VNet route all if not exists" `
    -description "This policy audits that all traffic originating from a web app is routed through Regional VNet integration" `
    -Policy 'https://raw.githubusercontent.com/DanielLarsenNZ/azure-policy/master/samples/WebApp/web-app-vnet-route-all-enabled/azurepolicy.rules.json' `
    -Parameter 'https://raw.githubusercontent.com/DanielLarsenNZ/azure-policy/master/samples/WebApp/web-app-vnet-route-all-enabled/azurepolicy.parameters.json' `
    -Mode Indexed
$definition

$scope = Get-AzResourceGroup -Name 'helloprivate-rg'
$scope
$assignment = New-AzPolicyAssignment -Name 'audit-helloprivate-rg-web-app-vnet-route-all-enabled' -Scope $scope.ResourceId -PolicyDefinition $definition
$assignment

````

## Try with CLI

````cli
az policy definition create --name 'audit-web-app-vnet-route-all-enabled' --display-name 'Audit Web App VNet route all if not exists' --description 'This policy audits that all traffic originating from a web app is routed through Regional VNet integration' --rules 'https://raw.githubusercontent.com/DanielLarsenNZ/azure-policy/master/samples/WebApp/web-app-vnet-route-all-enabled/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/DanielLarsenNZ/azure-policy/master/samples/WebApp/web-app-vnet-route-all-enabled/azurepolicy.parameters.json' --mode Indexed

$scope = ( az group show -n 'helloprivate-rg' | ConvertFrom-Json ).ResourceId
$scope

az policy assignment create --name 'audit-helloprivate-rg-web-app-vnet-route-all-enabled' --scope $scope --policy 'audit-web-app-vnet-route-all-enabled'
````
