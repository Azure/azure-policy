# Apply Diagnostic Settings for Azure Key Vault to a Log Analytics Workspace

This policy automatically deploys diagnostic settings for Azure Key Vault to a defined Log Analytics Workspace.

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FMonitoring%2Fapply-diagnostic-setting-keyvault-loganalytics%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "apply-diagnostic-setting-keyvault-loganalytics" -DisplayName "Apply Diagnostic Settings for Azure Key Vault to a Log Analytics Workspace" -description "This policy automatically deploys diagnostic settings for Azure Key Vault to point to a Log Analytics Workspace." -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Monitoring/apply-diagnostic-setting-keyvault-loganalytics/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Monitoring/apply-diagnostic-setting-keyvault-loganalytics/azurepolicy.parameters.json' -Mode Indexed
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope> -profileName <profileName> -logAnalytics <logAnalytics> -azureRegions <azureRegions> -metricsEnabled <metricsEnabled> -logsEnabled <logsEnabled> -PolicyDefinition $definition
$assignment 
````

## Try with CLI

````cli

az policy definition create --name 'apply-diagnostic-setting-keyvault-loganalytics' --display-name 'Apply Diagnostic Settings for Azure Key Vault to a Log Analytics Workspace' --description 'This policy automatically deploys diagnostic settings to Azure Key Vault supporting a Log Analytics Workspace.' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Monitoring/apply-diagnostic-setting-keyvault-loganalytics/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Monitoring/apply-diagnostic-setting-keyvault-loganalytics/azurepolicy.parameters.json' --mode Indexed

az policy assignment create --name <assignmentname> --scope <scope> --params "{ 'profileName': { 'value': '<profileName>' }, 'logAnalytics': { 'value': '<logAnalytics>' },'azureRegions': { 'value': '<azureRegions>' },'metricsEnabled': { 'value': '<metricsEnabled>' },'logsEnabled': { 'value': '<logsEnabled>' } }" --policy "apply-diagnostic-setting-keyvault-loganalytics"

````
