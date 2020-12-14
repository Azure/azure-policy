az policy definition create --name 'audit-web-app-vnet-route-all-enabled-azcli' `
    --display-name 'Audit Web App VNet route all if not exists' `
    --description 'This policy audits that all traffic originating from a web app is routed through Regional VNet integration' `
    --rules 'https://raw.githubusercontent.com/DanielLarsenNZ/azure-policy/master/samples/WebApp/web-app-vnet-route-all-enabled/azurepolicy.rules.json' `
    --params 'https://raw.githubusercontent.com/DanielLarsenNZ/azure-policy/master/samples/WebApp/web-app-vnet-route-all-enabled/azurepolicy.parameters.json' `
    --mode Indexed

$scope = ( az group show -n 'helloprivate-rg' | ConvertFrom-Json ).id
$scope

az policy assignment create --name 'audit-helloprivate-rg-web-app-vnet-route-all-enabled-azcli' --scope $scope `
    --policy 'audit-web-app-vnet-route-all-enabled-azcli'
