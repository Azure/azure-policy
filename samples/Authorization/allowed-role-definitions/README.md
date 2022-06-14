# Allowed Role Definitions

This policy defines an allow list of role definitions that can be used in IAM.

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FAuthorization%2Fallowed-role-definitions%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "allowed-role-definitions" -DisplayName "Allowed Role Definitions" -description "This policy defines an allow list of role definitions that can be used in IAM" -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Authorization/allowed-role-definitions/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Authorization/allowed-role-definitions/azurepolicy.parameters.json' -Mode All
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope>  -roleDefinitionIds <Approved Role Definitions> -PolicyDefinition $definition
$assignment
````



## Try with CLI

````cli

az policy definition create --name 'allowed-role-definitions' --display-name 'Allowed Role Definitions' --description 'This policy defines an allow list of role definitions that can be used in IAM' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Authorization/allowed-role-definitions/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Authorization/allowed-role-definitions/azurepolicy.parameters.json' --mode All

az policy assignment create --name <assignmentname> --scope <scope> --policy "allowed-role-definitions"

````
