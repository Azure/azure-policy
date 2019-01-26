# Audit enabling of diagnostic logs in App Services

Audit enabling of diagnostic logs on the app. This enables you to recreate activity trails for investigation purposes if a security incident occurs or your network is compromised

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FMonitoring%2Fapp-service-audit-diagnostic-logs%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "app-service-audit-diagnostic-logs" -DisplayName "Audit enabling of diagnostic logs in App Services" -description "Audit enabling of diagnostic logs on the app. This enables you to recreate activity trails for investigation purposes if a security incident occurs or your network is compromised" -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Monitoring/app-service-audit-diagnostic-logs/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Monitoring/app-service-audit-diagnostic-logs/azurepolicy.parameters.json' -Mode All
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope> -effect <effect> -PolicyDefinition $definition
$assignment 
````

## Try with CLI

````cli

az policy definition create --name 'app-service-audit-diagnostic-logs' --display-name 'Audit enabling of diagnostic logs in App Services' --description 'Audit enabling of diagnostic logs on the app. This enables you to recreate activity trails for investigation purposes if a security incident occurs or your network is compromised' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Monitoring/app-service-audit-diagnostic-logs/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Monitoring/app-service-audit-diagnostic-logs/azurepolicy.parameters.json' --mode All

az policy assignment create --name <assignmentname> --scope <scope> --params "{'effect':{'value':'<effect>'}}" --policy "app-service-audit-diagnostic-logs" 

````
