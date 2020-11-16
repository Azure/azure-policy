$definition = New-AzPolicyDefinition -Name "web-app-vnet-route-all-enabled" -DisplayName "Enforce Web App VNet route all" `
    -description "This policy ensures that all traffic originating from a web app is routed through Regional VNet integration" `
    -Policy './azurepolicy.rules.json' `
    -Parameter './azurepolicy.parameters.json' -Mode Indexed
$definition

$scope = Get-AzResourceGroup -Name 'helloprivate-rg'
$scope
$assignment = New-AzPolicyAssignment -Name 'helloprivate-rg-web-app-vnet-route-all-enabled' -Scope $scope.ResourceId -PolicyDefinition $definition
$assignment
