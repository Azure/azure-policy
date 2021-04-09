#!/bin/bash
set -e

rg='vnetrouteall-rg'
policy='audit-vnetrouteall-enabled' 
assignment="$rg-audit-vnetrouteall-enabled"

az policy definition create --name $policy \
    --display-name 'Audit App Service vnetRouteAllEnabled' \
    --description 'Audits that vnetRouteAllEnabled is true, ensuring all traffic originating from App is routed through VNet integration' \
    --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/WebApp/web-app-vnet-route-all-enabled/azurepolicy.rules.json' \
    --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/WebApp/web-app-vnet-route-all-enabled/azurepolicy.parameters.json' \
    --mode Indexed

scope=$( az group show -n $rg --query 'id' -o tsv )

az policy assignment create --name $assignment --scope $scope --policy $policy

# az policy state trigger-scan -g 'vnetrouteall-rg'