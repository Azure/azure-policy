# Allow resource creation if 'department' tag set

Allows resource creation only if the 'department' tag is set

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/?feature.customportal=false&microsoft_azure_policy=true&microsoft_azure_policy_policyinsights=true&feature.microsoft_azure_security_policy=true&microsoft_azure_marketplace_policy=true#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2Fbuilt-in-policy%2Fdepartment-tag-required%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzureRmPolicyDefinition -Name "department-tag-required" -DisplayName "Allow resource creation if 'department' tag set" -description "Allows resource creation only if the 'department' tag is set" -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/built-in-policy/department-tag-required/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/built-in-policy/department-tag-required/azurepolicy.parameters.json' -Mode All
$definition
$assignment = New-AzureRMPolicyAssignment -Name <assignmentname> -Scope <scope> -PolicyDefinition $definition
$assignment 
````

## Try with CLI

````cli

az policy definition create --name 'department-tag-required' --display-name 'Allow resource creation if 'department' tag set' --description 'Allows resource creation only if the 'department' tag is set' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/built-in-policy/department-tag-required/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/built-in-policy/department-tag-required/azurepolicy.parameters.json' --mode All

az policy assignment create --name <assignmentname> --scope <scope> --policy "department-tag-required" 

````
