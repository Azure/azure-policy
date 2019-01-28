# Apply Diagnostic Settings for Network Security Groups

This policy automatically deploys diagnostic settings to network security groups.

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FMonitoring%2Fapply-diagnostic-setting-network-security-group%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "apply-diagnostic-setting-network-security-group" -DisplayName "Apply Diagnostic Settings for Network Security Groups" -description "This policy automatically deploys diagnostic settings to network security groups." -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Monitoring/apply-diagnostic-setting-network-security-group/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Monitoring/apply-diagnostic-setting-network-security-group/azurepolicy.parameters.json' -Mode Indexed
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope> -storagePrefix <storagePrefix> -rgName <rgName> -PolicyDefinition $definition
$assignment 
````

## Try with CLI

````cli

az policy definition create --name 'apply-diagnostic-setting-network-security-group' --display-name 'Apply Diagnostic Settings for Network Security Groups' --description 'This policy automatically deploys diagnostic settings to network security groups.' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Monitoring/apply-diagnostic-setting-network-security-group/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Monitoring/apply-diagnostic-setting-network-security-group/azurepolicy.parameters.json' --mode Indexed

az policy assignment create --name <assignmentname> --scope <scope> --params "{ 'storagePrefix': { 'value': '<storagePrefix>' }, 'rgName': { 'value': '<rgName>' } }" --policy "apply-diagnostic-setting-network-security-group"

````
