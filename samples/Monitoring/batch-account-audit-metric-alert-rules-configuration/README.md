# Audit configuration of metric alert rules on Batch accounts

Audit configuration of metric alert rules on Batch account to enable the required metric

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FMonitoring%2Fbatch-account-audit-metric-alert-rules-configuration%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "batch-account-audit-metric-alert-rules-configuration" -DisplayName "Audit configuration of metric alert rules on Batch accounts" -description "Audit configuration of metric alert rules on Batch account to enable the required metric" -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Monitoring/batch-account-audit-metric-alert-rules-configuration/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Monitoring/batch-account-audit-metric-alert-rules-configuration/azurepolicy.parameters.json' -Mode Indexed
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope> -metricName <metricName> -PolicyDefinition $definition
$assignment 
````

## Try with CLI

````cli

az policy definition create --name 'batch-account-audit-metric-alert-rules-configuration' --display-name 'Audit configuration of metric alert rules on Batch accounts' --description 'Audit configuration of metric alert rules on Batch account to enable the required metric' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Monitoring/batch-account-audit-metric-alert-rules-configuration/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Monitoring/batch-account-audit-metric-alert-rules-configuration/azurepolicy.parameters.json' --mode Indexed

az policy assignment create --name <assignmentname> --scope <scope> --params "{'metricName':{'value':'<metricName>'}}" --policy "batch-account-audit-metric-alert-rules-configuration" 

````
