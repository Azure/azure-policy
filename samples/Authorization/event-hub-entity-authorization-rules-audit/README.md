# Audit existence of authorization rules on Event Hub entities

Audit existence of authorization rules on Event Hub entities to grant least-privileged access

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/?feature.customportal=false&microsoft_azure_policy=true&microsoft_azure_policy_policyinsights=true&feature.microsoft_azure_security_policy=true&microsoft_azure_marketplace_policy=true#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FAuthorization%2Fevent-hub-entity-authorization-rules-audit%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzureRmPolicyDefinition -Name "event-hub-entity-authorization-rules-audit" -DisplayName "Audit existence of authorization rules on Event Hub entities" -description "Audit existence of authorization rules on Event Hub entities to grant least-privileged access" -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Authorization/event-hub-entity-authorization-rules-audit/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Authorization/event-hub-entity-authorization-rules-audit/azurepolicy.parameters.json' -Mode Indexed
$definition
$assignment = New-AzureRMPolicyAssignment -Name <assignmentname> -Scope <scope> -effect <effect> -PolicyDefinition $definition
$assignment 
````

## Try with CLI

````cli

az policy definition create --name 'event-hub-entity-authorization-rules-audit' --display-name 'Audit existence of authorization rules on Event Hub entities' --description 'Audit existence of authorization rules on Event Hub entities to grant least-privileged access' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Authorization/event-hub-entity-authorization-rules-audit/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Authorization/event-hub-entity-authorization-rules-audit/azurepolicy.parameters.json' --mode Indexed

az policy assignment create --name <assignmentname> --scope <scope> --effect <effect> --policy "event-hub-entity-authorization-rules-audit" 

````
