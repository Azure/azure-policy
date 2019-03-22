# Apply Diagnostic Settings for Azure SQL to a Regional Event Hub

This policy automatically deploys diagnostic settings for Azure SQL supporting a regional Event Hub as a sink point.

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FMonitoring%2Fapply-diagnostic-setting-azsql-eventhub%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "apply-diagnostic-setting-azsql-eventhub" -DisplayName "Apply Diagnostic Settings for Azure SQL to a Regional Event Hub" -description "This policy automatically deploys diagnostic settings for Azure SQL to point to a regional Event Hub." -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Monitoring/apply-diagnostic-setting-azsql-eventhub/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Monitoring/apply-diagnostic-setting-azsql-eventhub/azurepolicy.parameters.json' -Mode Indexed
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope> -profileName <profileName> -eventHubName <eventHubName> -eventHubRuleId <eventHubRuleId> -azureRegions <azureRegions> -metricsEnabled <metricsEnabled> -logsEnabled <logsEnabled> -PolicyDefinition $definition
$assignment 
````

## Try with CLI

````cli

az policy definition create --name 'apply-diagnostic-setting-azsql-eventhub' --display-name 'Apply Diagnostic Settings for Azure SQL to a regional Event Hub' --description 'This policy automatically deploys diagnostic settings to Azure SQL DBs supporting a regional Event Hub.' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Monitoring/apply-diagnostic-setting-azsql-eventhub/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Monitoring/apply-diagnostic-setting-azsql-eventhub/azurepolicy.parameters.json' --mode Indexed

az policy assignment create --name <assignmentname> --scope <scope> --params "{ 'profileName': { 'value': '<profileName>' }, 'eventHubName': { 'value': '<eventHubName>' },'eventHubRuleId': { 'value': '<eventHubRuleId>' },'azureRegions': { 'value': '<azureRegions>' },'metricsEnabled': { 'value': '<metricsEnabled>' },'logsEnabled': { 'value': '<logsEnabled>' } }" --policy "apply-diagnostic-setting-azsql-eventhub"

````
