# {{displayName}}

{{description}}

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/?feature.customportal=false&microsoft_azure_policy=true#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade)

## Try on PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "{{policyName}}" -DisplayName "{{displayName}}" -description "{{description}}" -Policy 'https://raw.githubusercontent.com/Azure/azure-policy-samples/master/samples/{{path}}/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy-samples/master/samples/{{path}}/azurepolicy.parameters.json' -Mode All
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope> -PolicyDefinition $definition
$assignment 
````



## Try with CLI

````cli

az policy definition create –-name "{{policyName}}" --display-name "{{displayName}}" --description "{{description}}" --rules 'https://raw.githubusercontent.com/Azure/azure-policy-samples/master/samples/{{path}}/azurepolicy.rules.json' –-params 'https://raw.githubusercontent.com/Azure/azure-policy-samples/master/samples/{{path}}/azurepolicy.parameters.json' -mode All

az policy assignment create --name <assignmentname> --scope <scope> --policy "{{policyName}}" 

````
