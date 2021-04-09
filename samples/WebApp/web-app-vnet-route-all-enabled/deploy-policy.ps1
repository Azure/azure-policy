$ErrorActionPreference = 'Stop'

$rg = 'vnetrouteall-rg'

$definition = New-AzPolicyDefinition `
    -Name 'audit-vnetrouteall-enabled' `
    -DisplayName 'Audit App Service vnetRouteAllEnabled' `
    -Description 'Audits that vnetRouteAllEnabled is true, ensuring all traffic originating from App is routed through VNet integration' `
    -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/WebApp/web-app-vnet-route-all-enabled/azurepolicy.rules.json' `
    -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/WebApp/web-app-vnet-route-all-enabled/azurepolicy.parameters.json' `
    -Mode Indexed

$scope = Get-AzResourceGroup -Name $rg
New-AzPolicyAssignment -Name "$rg-audit-vnetrouteall-enabled" -Scope $scope.ResourceId -PolicyDefinition $definition
