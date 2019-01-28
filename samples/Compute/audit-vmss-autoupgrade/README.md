# Audit Virtual Machine Scale Sets without automatic OS upgrade enabled

This policy audits any Virtual Machine Scale Set that does not have automatic OS upgrade enabled. More information on automatic OS upgrade is available [here](https://docs.microsoft.com/en-us/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-automatic-upgrade).

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FCompute%2Faudit-vmss-autoosupgrade%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "audit-vmss-autoosupgrade" -DisplayName "Audit Virtual Machine Scale Sets without automatic OS upgrade enabled" -description "This policy audits any Virtual Machine Scale Set that does not have automatic OS upgrade enabled." -Policy "https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Compute/audit-vmss-autoosupgrade/azurepolicy.rules.json" -Mode Indexed
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope> -PolicyDefinition $definition
$assignment
````

## Try with CLI

````cli

az policy definition create --name 'audit-vmss-autoosupgrade' --display-name 'Audit Virtual Machine Scale Sets without automatic OS upgrade enabled' --description 'This policy audits any Virtual Machine Scale Set that does not have automatic OS upgrade enabled.' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Compute/audit-vmss-autoosupgrade/azurepolicy.rules.json' --mode Indexed

az policy assignment create --name <assignmentname> --scope <scope> --policy "audit-vmss-autoosupgrade" 

````
