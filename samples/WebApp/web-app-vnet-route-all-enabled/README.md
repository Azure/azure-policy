# Enforce Web App VNet route all

This policy audits that the `vNetRouteAllEnabled` ARM property is set to true, forcing all traffic that originates in an App Service to be routed via [VNet Integration].

> ℹ `vNetRouteAllEnabled` property has the same effect as creating an App Setting `WEBSITE_VNET_ROUTE_ALL=1`, however policy will only take effect if the property has been set using ARM.

For this policy to take effect:

1. App Service must be deployed using an ARM API Version >= `2019-04-01`
1. App Service (`Microsoft.Web/sites`) property `siteConfig` > `vnetRouteAllEnabled` must be set to `true` using an ARM template, e.g.

```json
"resources": [
    {
      "type": "Microsoft.Web/sites",
      "apiVersion": "2020-09-01",
      "name": "[parameters('appName')]",
      "location": "[parameters('location')]",
      "kind": "app",
      "dependsOn": [
        
      ],
      "properties": {
        "serverFarmId": "[resourceId('Microsoft.Web/serverFarms', parameters('appServicePlanName'))]",
        "siteConfig": {
          "vnetRouteAllEnabled": true
        }
      }
    }
  ]
```

> ℹ The `vnetRouteAllEnabled` property is currently only supported in the POST and PUT operations on the ARM API. Getting the property value will always return `null`.

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FWebApp%2Fweb-app-vnet-route-all-enabled%2Fazurepolicy.json)

## Try with PowerShell

```powershell
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
```

## Try with CLI

```bash
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

```

<!-- link refs -->
[VNet Integration]:(https://docs.microsoft.com/en-us/azure/app-service/web-sites-integrate-with-vne0t)