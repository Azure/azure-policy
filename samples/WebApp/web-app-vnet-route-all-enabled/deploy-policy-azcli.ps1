$policy = 'audit-vnetrouteall-enabled-300320211631' 
$assignment = 'hellovnetrouteall-rg-audit-vnetrouteall-enabled-300320211631'

az policy definition create --name $policy  `
    --display-name 'Audit Web App VNet route all if not exists' `
    --description 'This policy audits that all traffic originating from a web app is routed through Regional VNet integration' `
    --rules 'https://raw.githubusercontent.com/DanielLarsenNZ/azure-policy/master/samples/WebApp/web-app-vnet-route-all-enabled/azurepolicy.rules.json' `
    --params 'https://raw.githubusercontent.com/DanielLarsenNZ/azure-policy/master/samples/WebApp/web-app-vnet-route-all-enabled/azurepolicy.parameters.json' `
    --mode Indexed

az policy definition create --name "$policy-alias"  `
    --display-name 'Audit Web App VNet route all if not exists' `
    --description 'This policy audits that all traffic originating from a web app is routed through Regional VNet integration' `
    --rules 'https://raw.githubusercontent.com/DanielLarsenNZ/azure-policy/master/samples/WebApp/web-app-vnet-route-all-enabled/azurepolicy-alias.rules.json' `
    --params 'https://raw.githubusercontent.com/DanielLarsenNZ/azure-policy/master/samples/WebApp/web-app-vnet-route-all-enabled/azurepolicy.parameters.json' `
    --mode Indexed

$scope = ( az group show -n 'hellovnetrouteall-rg' | ConvertFrom-Json ).id
$scope

az policy assignment create --name $assignment --scope $scope --policy $policy

az policy assignment create --name "$assignment-alias" --scope $scope --policy "$policy-alias"

#az policy state trigger-scan -g 'hellovnetrouteall-rg'