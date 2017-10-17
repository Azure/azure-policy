# Apply tag and its default value

Applies a required tag and its default value if it is not specified by the user.

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/?feature.customportal=false&microsoft_azure_policy=true#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade)

## Try with PowerShell

````powershell
$definition = New-AzureRmPolicyDefinition -Name "apply-default-tag-value" -DisplayName "Apply tag and its default value" -description "Applies a required tag and its default value if it is not specified by the user." -Policy 'https://raw.githubusercontent.com/Azure/azure-policy-samples/master/samples/built-in-policy/apply-default-tag-value/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy-samples/master/samples/built-in-policy/apply-default-tag-value/azurepolicy.parameters.json' -Mode All
$definition
$assignment = New-AzureRMPolicyAssignment -Name <assignmentname> -Scope <scope> -PolicyDefinition $definition
$assignment 
````



## Try with CLI

````cli

az policy definition create --name 'apply-default-tag-value' --display-name 'Apply tag and its default value' --description 'Applies a required tag and its default value if it is not specified by the user.' --rules 'https://raw.githubusercontent.com/Azure/azure-policy-samples/master/samples/built-in-policy/apply-default-tag-value/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy-samples/master/samples/built-in-policy/apply-default-tag-value/azurepolicy.parameters.json' --mode All

az policy assignment create --name <assignmentname> --scope <scope> --policy "apply-default-tag-value" 

````
