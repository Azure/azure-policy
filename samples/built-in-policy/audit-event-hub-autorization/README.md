# Audit authorization rules on Event Hub namespaces

Event Hub clients should not use a namespace level access policy that provides access to all queues and topics in a namespace. To align with the least previlege security model, you shoud create access policies at the entity level for queues and topics to provide access to only the specific entity

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/?feature.customportal=false&microsoft_azure_policy=true&microsoft_azure_policy_policyinsights=true&feature.microsoft_azure_security_policy=true&microsoft_azure_marketplace_policy=true#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2Fbuilt-in-policy%2Faudit-event-hub-autorization%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzureRmPolicyDefinition -Name "audit-event-hub-autorization" -DisplayName "Audit authorization rules on Event Hub namespaces" -description "Event Hub clients should not use a namespace level access policy that provides access to all queues and topics in a namespace. To align with the least previlege security model, you shoud create access policies at the entity level for queues and topics to provide access to only the specific entity" -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/built-in-policy/audit-event-hub-autorization/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/built-in-policy/audit-event-hub-autorization/azurepolicy.parameters.json' -Mode All
$definition
$assignment = New-AzureRMPolicyAssignment -Name <assignmentname> -Scope <scope> -effect <effect> -PolicyDefinition $definition
$assignment 
````

## Try with CLI

````cli

az policy definition create --name 'audit-event-hub-autorization' --display-name 'Audit authorization rules on Event Hub namespaces' --description 'Event Hub clients should not use a namespace level access policy that provides access to all queues and topics in a namespace. To align with the least previlege security model, you shoud create access policies at the entity level for queues and topics to provide access to only the specific entity' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/built-in-policy/audit-event-hub-autorization/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/built-in-policy/audit-event-hub-autorization/azurepolicy.parameters.json' --mode All

az policy assignment create --name <assignmentname> --scope <scope> --policy "audit-event-hub-autorization" 

````
