# Enable automatic OS upgrade on Virtual Machine Scale Sets

This policy enables automatic OS upgrade on Virtual Machine Scale Sets. New scale sets will have automatic OS upgrade enabled automatically. Existing scale sets that are not opted into automatic OS upgrade will be marked as non-compliant and can be enabled through policy remediation. More information on automatic OS upgrade is available [here](https://docs.microsoft.com/en-us/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-automatic-upgrade).

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FCompute%2Fdeploy-vmss-autoosupgrade%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "deploy-vmss-autoosupgrade" -DisplayName "Enable automatic OS upgrade on Virtual Machine Scale Sets" -description "This policy enables automatic OS upgrade on Virtual Machine Scale Sets. New scale sets will have automatic OS upgrade enabled automatically. Existing scale sets that are not opted into automatic OS upgrade will be marked as non-compliant and can be enabled through policy remediation." -Policy "https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Compute/deploy-vmss-autoosupgrade/azurepolicy.rules.json" -Mode Indexed
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope> -Location <location> -AssignIdentity -PolicyDefinition $definition
$assignment

# Assign the permissions to the assignment's identity
$roleDefinitionIds = $definition.Properties.policyRule.then.details.roleDefinitionIds

if ($roleDefinitionIds.Count -gt 0)
{
    $roleDefinitionIds | ForEach-Object {
        $roleDefId = $_.Split("/") | Select-Object -Last 1
        New-AzRoleAssignment -Scope $assignment.Properties.Scope -ObjectId $assignment.Identity.PrincipalId -RoleDefinitionId $roleDefId
    }
}
````

## Try with CLI

````cli

az policy definition create --name 'deploy-vmss-autoosupgrade' --display-name 'Enable automatic OS upgrade on Virtual Machine Scale Sets' --description 'This policy enables automatic OS upgrade on Virtual Machine Scale Sets. New scale sets will have automatic OS upgrade enabled automatically. Existing scale sets that are not opted into automatic OS upgrade will be marked as non-compliant and can be enabled through policy remediation.' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Compute/deploy-vmss-autoosupgrade/azurepolicy.rules.json' --mode Indexed

## Assignment of deployIfNotExists policies is not supported in CLI yet

````
