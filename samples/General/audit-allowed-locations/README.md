# Audit for allowed locations

This policy enables you to audit the locations where your resources have been deployed. Use this to understand what is within your environment and if it matches company guidelines.


## Try on Portal


[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/?feature.customportal=false&microsoft_azure_policy=true&microsoft_azure_policy_policyinsights=true&feature.microsoft_azure_security_policy=true&microsoft_azure_marketplace_policy=true#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FLocation%2Faudit-allowed-locations%2Fazurepolicy.json)



## Try with PowerShell

````powershell
$definition = New-AzureRmPolicyDefinition -Name "audit-location-deployments" -DisplayName "Audit for allowed locations" -description "This policy enables you to audit the locations where your resources have been deployed. Use this to understand what is within your environment and if it matches company guidelines." -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Location/audit-allowed-locations/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Location/audit-allowed-locations/azurepolicy.parameters.json' -Mode Indexed
$definition
$assignment = New-AzureRMPolicyAssignment -Name <assignmentname> -Scope <scope>  -PolicyDefinition $definition
$assignment 
````


## Try with CLI

````cli

az policy definition create --name 'audit-location-deployments' --display-name 'Audit for allowed locations --description 'This policy enables you to audit the locations where your resources have been deployed. Use this to understand what is within your environment and if it matches company guidelines.' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Location/audit-allowed-locations/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Location/audit-allowed-locations/azurepolicy.parameters.json' --mode Indexed

az policy assignment create --name <assignmentname> --scope <scope> --policy "audit-location-deployments" 

````
