# Allowed Express Route SKUs

This policy enables you to specify a set of express route SKUs that your organization can deploy.

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FNetwork%2Fexpress-route-skus%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "express-route-skus" -DisplayName "Allowed Express Route SKUs" -description "This policy enables you to specify a set of express route SKUs that your organization can deploy." -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Network/express-route-skus/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Network/express-route-skus/azurepolicy.parameters.json' -Mode All
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope>  -listOfAllowedSKUs <Allowed SKUs> -PolicyDefinition $definition
$assignment 
````



## Try with CLI

````cli

az policy definition create --name 'express-route-skus' --display-name 'Allowed Express Route SKUs' --description 'This policy enables you to specify a set of express route SKUs that your organization can deploy.' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Network/express-route-skus/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Network/express-route-skus/azurepolicy.parameters.json' --mode All

az policy assignment create --name <assignmentname> --scope <scope> --policy "express-route-skus" 

````
