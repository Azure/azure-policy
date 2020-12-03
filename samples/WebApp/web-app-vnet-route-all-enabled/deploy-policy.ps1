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
