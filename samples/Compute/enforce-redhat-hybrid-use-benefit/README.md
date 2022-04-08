# Enforce hybrid use benefit

This policy will enforce usage of hybrid use benefit.

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FCompute%2Fenforce-redhat-hybrid-use-benefit%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "enforce-redhat-hybrid-use-benefit" -DisplayName "Enforce Redhat hybrid use benefit" -description "This policy will enforce usage of hybrid use benefit on RedHat bring-your-own-subscription (BYOS) operating systems." -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Compute/enforce-redhat-hybrid-use-benefit/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Compute/enforce-redhat-hybrid-use-benefit/azurepolicy.parameters.json' -Mode All
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope>  -PolicyDefinition $definition
$assignment 
````



## Try with CLI

````cli

az policy definition create --name 'enforce-redhat-hybrid-use-benefit' --display-name 'Enforce Redhat hybrid use benefit' --description 'This policy will enforce usage of hybrid use benefit on RedHat bring-your-own-subscription (BYOS) operating systems.' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Compute/enforce-redhat-hybrid-use-benefit/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Compute/enforce-redhat-hybrid-use-benefit/azurepolicy.parameters.json' --mode All

az policy assignment create --name <assignmentname> --scope <scope> --policy "enforce-redhat-hybrid-use-benefit" 

````
