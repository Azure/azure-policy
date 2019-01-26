# Deploy a diagnostics setting for keyvault resource to stream to eventhub namespace

DeployIfNotExists policy to automatically configure a diagnostic setting for key vault resources which will stream to a specified event hub namespace.

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FKeyVault%2Fdeploy-eventhub-diagnostic-setting-for-keyvault%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "deploy-eventhub-diagnostic-setting-for-keyvault" -DisplayName "Deploy diagnostic setting for key vault to stream to event hub" -description "Automatically configure a diagnostic setting for key vault resources which will stream to a specified event hub namespace." -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/KeyVault/deploy-eventhub-diagnostic-setting-for-keyvault/azurepolicy.rules.json' -Mode Indexed
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope> -PolicyDefinition $definition
$assignment 
````



## Try with CLI

````cli

az policy definition create --name 'deploy-eventhub-diagnostic-setting-for-keyvault' --display-name 'Deploy diagnostic setting for key vault to stream to event hub' --description 'Automatically configure a diagnostic setting for key vault resources which will stream to a specified event hub namespace.' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/KeyVault/deploy-eventhub-diagnostic-setting-for-keyvault/azurepolicy.rules.json' --mode Indexed

az policy assignment create --name <assignmentname> --scope <scope> --policy 'deploy-eventhub-diagnostic-setting-for-keyvault' 

````
