# Allowed Peering Location for Express Route

This policy enables you to specify a set of allowed peering location for express route

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FNetwork%2Fexpress-route-peeringLocation%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "express-route-peeringLocation" -DisplayName "Allowed Peering Location for Express Route" -description "This policy enables you to specify a set of allowed peering location for express route" -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Network/express-route-peeringLocation/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Network/express-route-peeringLocation/azurepolicy.parameters.json' -Mode All
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope>  -listOfLocations <Allowed Peering Locations> -PolicyDefinition $definition
$assignment 
````



## Try with CLI

````cli

az policy definition create --name 'express-route-peeringLocation' --display-name 'Allowed Peering Location for Express Route' --description 'This policy enables you to specify a set of allowed peering location for express route' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Network/express-route-peeringLocation/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Network/express-route-peeringLocation/azurepolicy.parameters.json' --mode All

az policy assignment create --name <assignmentname> --scope <scope> --policy "express-route-peeringLocation" 

````
