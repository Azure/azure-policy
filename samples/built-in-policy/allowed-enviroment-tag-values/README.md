# Allow resource creation if 'environment' tag value in allowed values

Allows resource creation if the 'environment' tag is set to one of the following values: production, dev, test, staging

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/?feature.customportal=false&microsoft_azure_policy=true&microsoft_azure_policy_policyinsights=true&feature.microsoft_azure_security_policy=true&microsoft_azure_marketplace_policy=true#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2Fbuilt-in-policy%2Fallowed-enviroment-tag-values%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzureRmPolicyDefinition -Name "allowed-enviroment-tag-values" -DisplayName "Allow resource creation if 'environment' tag value in allowed values" -description "Allows resource creation if the 'environment' tag is set to one of the following values: production, dev, test, staging" -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/built-in-policy/allowed-enviroment-tag-values/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/built-in-policy/allowed-enviroment-tag-values/azurepolicy.parameters.json' -Mode All
$definition
$assignment = New-AzureRMPolicyAssignment -Name <assignmentname> -Scope <scope> -PolicyDefinition $definition
$assignment 
````

## Try with CLI

````cli

az policy definition create --name 'allowed-enviroment-tag-values' --display-name 'Allow resource creation if 'environment' tag value in allowed values' --description 'Allows resource creation if the 'environment' tag is set to one of the following values: production, dev, test, staging' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/built-in-policy/allowed-enviroment-tag-values/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/built-in-policy/allowed-enviroment-tag-values/azurepolicy.parameters.json' --mode All

az policy assignment create --name <assignmentname> --scope <scope> --policy "allowed-enviroment-tag-values" 

````
