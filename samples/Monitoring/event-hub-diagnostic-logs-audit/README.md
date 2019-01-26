# Audit enabling of diagnostic logs in Event Hub

Audit enabling of logs and retain them up to a year. This enables recreation of activity trails for investigation purposes when a security incident occurs or your network is compromised

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FMonitoring%2Fevent-hub-diagnostic-logs-audit%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "event-hub-diagnostic-logs-audit" -DisplayName "Audit enabling of diagnostic logs in Event Hub" -description "Audit enabling of logs and retain them up to a year. This enables recreation of activity trails for investigation purposes when a security incident occurs or your network is compromised" -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Monitoring/event-hub-diagnostic-logs-audit/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Monitoring/event-hub-diagnostic-logs-audit/azurepolicy.parameters.json' -Mode Indexed
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope> -requiredRetentionDays <requiredRetentionDays> -PolicyDefinition $definition
$assignment 
````

## Try with CLI

````cli

az policy definition create --name 'event-hub-diagnostic-logs-audit' --display-name 'Audit enabling of diagnostic logs in Event Hub' --description 'Audit enabling of logs and retain them up to a year. This enables recreation of activity trails for investigation purposes when a security incident occurs or your network is compromised' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Monitoring/event-hub-diagnostic-logs-audit/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Monitoring/event-hub-diagnostic-logs-audit/azurepolicy.parameters.json' --mode Indexed

az policy assignment create --name <assignmentname> --scope <scope> --params "{'requiredRetentionDays':{'value': '<requiredRetentionDays>'}}" --policy "event-hub-diagnostic-logs-audit" 

````
