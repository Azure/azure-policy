# Enforce https traffic for all App Services

This policy ensures that only https traffic is allowed on all App Services

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FAppService%2Fapps-service-https-traffic-only%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "apps-service-https-traffic-only" -DisplayName "Enforce https traffic on all App Services" -description "This policy ensures that only https traffic is allowed on all App Services" -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/AppService/apps-service-https-traffic-only/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/AppService/apps-service-https-traffic-only/azurepolicy.parameters.json' -Mode Indexed
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope> -PolicyDefinition $definition
$assignment
````

## Try with CLI

````cli

az policy definition create --name 'apps-service-https-traffic-only' --display-name 'Enforce https traffic on all App Services' --description 'This policy ensures that only https traffic is allowed on all App Services' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/AppService/apps-service-https-traffic-only/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/AppService/apps-service-https-traffic-only/azurepolicy.parameters.json' --mode Indexed

az policy assignment create --name <assignmentname> --scope <scope> --policy "apps-service-https-traffic-only"

````
