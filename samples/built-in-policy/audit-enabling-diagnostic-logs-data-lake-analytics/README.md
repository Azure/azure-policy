# Audit enabling of diagnostic logs in Data Lake Analytics

Audit enabling of logs and retain them up to a year. This enables you to recreate activity trails for investigation purposes when a security incident occurs or your network is compromised

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/?feature.customportal=false&microsoft_azure_policy=true&microsoft_azure_policy_policyinsights=true&feature.microsoft_azure_security_policy=true&microsoft_azure_marketplace_policy=true#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2Fbuilt-in-policy%2Faudit-enabling-diagnostic-logs-data-lake-analytics%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzureRmPolicyDefinition -Name "audit-enabling-diagnostic-logs-data-lake-analytics" -DisplayName "Audit enabling of diagnostic logs in Data Lake Analytics" -description "Audit enabling of logs and retain them up to a year. This enables you to recreate activity trails for investigation purposes when a security incident occurs or your network is compromised" -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/built-in-policy/audit-enabling-diagnostic-logs-data-lake-analytics/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/built-in-policy/audit-enabling-diagnostic-logs-data-lake-analytics/azurepolicy.parameters.json' -Mode All
$definition
$assignment = New-AzureRMPolicyAssignment -Name <assignmentname> -Scope <scope> -effect <effect> -requiredRetentionDays <requiredRetentionDays> -PolicyDefinition $definition
$assignment 
````

## Try with CLI

````cli

az policy definition create --name 'audit-enabling-diagnostic-logs-data-lake-analytics' --display-name 'Audit enabling of diagnostic logs in Data Lake Analytics' --description 'Audit enabling of logs and retain them up to a year. This enables you to recreate activity trails for investigation purposes when a security incident occurs or your network is compromised' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/built-in-policy/audit-enabling-diagnostic-logs-data-lake-analytics/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/built-in-policy/audit-enabling-diagnostic-logs-data-lake-analytics/azurepolicy.parameters.json' --mode All

az policy assignment create --name <assignmentname> --scope <scope> --policy "audit-enabling-diagnostic-logs-data-lake-analytics" 

````
