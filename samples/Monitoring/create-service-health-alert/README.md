## Create / Audit Service Health Alerts @Scale

Audit oder deploy service health alerts on all new / existing subscription under a certain management group. A specific resource group is audited / created including a service health alert + action group.

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FMonitoring%2Fcreate-service-health-alert%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "create-service-health-alerts" -DisplayName "Create Service Health Alert" -description "Audit oder deploy service health alerts on all new / existing subscription under a certain management group. A specific resource group is audited / created including a service health alert + action group." -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Monitoring/create-service-health-alert/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Monitoring/create-service-health-alert/azurepolicy.parameters.json' -Mode All
$definition

$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope> -resourceGroupName <resourceGroupName> -actionGroupName <actionGroupName> -actionGroupShortName <actionGroupShortName> -emailAddress <emailAddress> -activityLogAlertName <activityLogAlertName> -PolicyDefinition $definition
$assignment 
````

## Try with CLI

````cli

az policy definition create --name 'create-service-health-alerts' --display-name 'Create Service Health Alert' --description 'Audit oder deploy service health alerts on all new / existing subscription under a certain management group. A specific resource group is audited / created including a service health alert + action group.' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Monitoring/create-service-health-alert/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Monitoring/create-service-health-alert/azurepolicy.parameters.json' --mode All

az policy assignment create --name <assignmentname> --scope <scope> --policy "create-service-health-alerts" 

````
