# Deploy Diagnostic logs settings for Data Lake Analytics to Log Analytics

Deploy auditing of diagnostic logs in Data Lake Analytics. This enables you to recreate activity trails for investigation purposes when a security incident occurs or your network is compromised

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2Fbuilt-in-policy%2Fdeploy-logAnalytics-diagnostic-setting-for-datalakeanalytics%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "deploy-logAnalytics-diagnostic-setting-for-datalakeanalytics" -DisplayName "Deploy auditing of diagnostic logs in Data Lake Analytics (send to Log Analytics workspace)." description "Deploy auditing of diagnostic logs in Data Lake Analytics. This enables you to recreate activity trails for investigation purposes when a security incident occurs or your network is compromised." -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/built-in-policy/deploy-logAnalytics-diagnostic-setting-for-datalakeanalytics/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/built-in-policy/deploy-logAnalytics-diagnostic-setting-for-datalakeanalytics/azurepolicy.parameters.json' -Mode All
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope> -PolicyDefinition $definition
$assignment
````

## Try with CLI

````cli

az policy definition create --name 'deploy-logAnalytics-diagnostic-setting-for-datalakeanalytics' --display-name 'Deploy auditing of diagnostic logs in Data Lake Analytics (send to Log Analytics workspace)' --description 'Deploy auditing of diagnostic logs in Data Lake Analytics. This enables you to recreate activity trails for investigation purposes when a security incident occurs or your network is compromised.' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/built-in-policy/deploy-logAnalytics-diagnostic-setting-for-datalakeanalytics/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/built-in-policy/deploy-logAnalytics-diagnostic-setting-for-datalakeanalytics/azurepolicy.parameters.json' --mode All

az policy assignment create --name <assignmentname> --scope <scope> --policy "deploy-logAnalytics-diagnostic-setting-for-datalakeanalytics"

````
