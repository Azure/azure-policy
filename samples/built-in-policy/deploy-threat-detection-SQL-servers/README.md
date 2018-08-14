# [Preview]: Deploy Threat Detection on SQL servers
deploy-threat-detection-SQL-servers
This policy ensures that Threat Detection is enabled on SQL Servers.

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/?feature.customportal=false&microsoft_azure_policy=true&microsoft_azure_policy_policyinsights=true&feature.microsoft_azure_security_policy=true&microsoft_azure_marketplace_policy=true#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2Fbuilt-in-policy%2Fdeploy-threat-detection-SQL-servers%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzureRmPolicyDefinition -Name "deploy-threat-detection-SQL-servers" -DisplayName "[Preview]: Deploy Threat Detection on SQL servers" -description "This policy ensures that Threat Detection is enabled on SQL Servers." -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/built-in-policy/deploy-threat-detection-SQL-servers/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/built-in-policy/deploy-threat-detection-SQL-servers/azurepolicy.parameters.json' -Mode All
$definition
$assignment = New-AzureRMPolicyAssignment -Name <assignmentname> -Scope <scope> -PolicyDefinition $definition
$assignment 
````

## Try with CLI

````cli

az policy definition create --name 'deploy-threat-detection-SQL-servers' --display-name '[Preview]: Deploy Threat Detection on SQL servers' --description 'This policy ensures that Threat Detection is enabled on SQL Servers.' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/built-in-policy/deploy-threat-detection-SQL-servers/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/built-in-policy/deploy-threat-detection-SQL-servers/azurepolicy.parameters.json' --mode All

az policy assignment create --name <assignmentname> --scope <scope> --policy "deploy-threat-detection-SQL-servers" 

````
