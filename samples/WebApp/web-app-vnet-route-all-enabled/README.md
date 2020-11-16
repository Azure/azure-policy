# Enforce https traffic for all Web Apps

This policy ensures that only https traffic is allowed on all Web Apps

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FWebApp%2Fweb-app-https-traffic-only%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "web-app-https-traffic-only" -DisplayName "Enforce https traffic on all Web Apps" -description "This policy ensures that only https traffic is allowed on all Web Apps" -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/WebApp/web-app-https-traffic-only/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/WebApp/web-app-https-traffic-only/azurepolicy.parameters.json' -Mode Indexed
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope> -PolicyDefinition $definition
$assignment
````

## Try with CLI

````cli

az policy definition create --name 'web-app-https-traffic-only' --display-name 'Enforce https traffic on all Web Apps' --description 'This policy ensures that only https traffic is allowed on all Web Apps' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/WebApp/web-app-https-traffic-only/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/WebApp/web-app-https-traffic-only/azurepolicy.parameters.json' --mode Indexed

az policy assignment create --name <assignmentname> --scope <scope> --policy "web-app-https-traffic-only"

````
