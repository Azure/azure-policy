az policy definition create --name 'audit-web-app-vnet-route-all-enabled-azcli' `
    --display-name 'Audit Web App VNet route all if not exists' `
    --description 'This policy audits that all traffic originating from a web app is routed through Regional VNet integration' `
    --rules 'https://raw.githubusercontent.com/DanielLarsenNZ/azure-policy/master/samples/WebApp/web-app-vnet-route-all-enabled/azurepolicy.rules.json' `
    --params 'https://raw.githubusercontent.com/DanielLarsenNZ/azure-policy/master/samples/WebApp/web-app-vnet-route-all-enabled/azurepolicy.parameters.json' `
    --mode Indexed

az policy definition create --name 'audit-web-app-vnet-route-all-enabled-azcli-false' `
    --display-name 'Audit Web App VNet route all if not not exists' `
    --description 'This policy audits that all traffic originating from a web app is routed through Regional VNet integration' `
    --rules 'https://raw.githubusercontent.com/DanielLarsenNZ/azure-policy/master/samples/WebApp/web-app-vnet-route-all-enabled/azurepolicy-false.rules.json' `
    --params 'https://raw.githubusercontent.com/DanielLarsenNZ/azure-policy/master/samples/WebApp/web-app-vnet-route-all-enabled/azurepolicy.parameters.json' `
    --mode Indexed

$scope = ( az group show -n 'hellovnetrouteall-rg' | ConvertFrom-Json ).id
$scope

az policy assignment create --name 'audit-hellovnetrouteall-rg-web-app-vnet-route-all-azcli' --scope $scope `
    --policy 'audit-web-app-vnet-route-all-enabled-azcli'

az policy assignment create --name 'audit-hellovnetrouteall-rg-web-app-vnet-route-all-azcli-false' --scope $scope `
    --policy 'audit-web-app-vnet-route-all-enabled-azcli-false'

#az policy state trigger-scan -g 'hellovnetrouteall-rg'