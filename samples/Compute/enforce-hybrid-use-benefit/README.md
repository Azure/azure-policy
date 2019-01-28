# Enforce hybrid use benefit

This policy will enforce usage of hybrid use benefit.

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FCompute%2Fenforce-hybrid-use-benefit%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "enforce-hybrid-use-benefit" -DisplayName "Enforce hybrid use benefit" -description "This policy will enforce usage of hybrid use benefit." -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Compute/enforce-hybrid-use-benefit/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Compute/enforce-hybrid-use-benefit/azurepolicy.parameters.json' -Mode All
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope>  -PolicyDefinition $definition
$assignment 
````



## Try with CLI

````cli

az policy definition create --name 'enforce-hybrid-use-benefit' --display-name 'Enforce hybrid use benefit' --description 'This policy will enforce usage of hybrid use benefit.' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Compute/enforce-hybrid-use-benefit/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Compute/enforce-hybrid-use-benefit/azurepolicy.parameters.json' --mode All

az policy assignment create --name <assignmentname> --scope <scope> --policy "enforce-hybrid-use-benefit" 

````
