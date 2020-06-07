## Onboard Azure VM and Arc connected machines to Azure Automation DSC

Deploys the DSC extension to onboard nodes to Azure Automation DSC. Does not assign a configuration.

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FAutomation%2Fonboard-to-automation-dsc%2Fazurepolicy.json)

## Try with Powershell

````powershell
$definition = New-AzPolicyDefinition -Name "onboard-to-automation-dsc" -DisplayName "Onboard Azure VM and Arc connected machines to Azure Automation DSC" -description "Deploys the DSC extension to onboard nodes to Azure Automation DSC. Does not assign a configuration." -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Automation/onboard-to-automation-dsc/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Automation/onboard-to-automation-dsc/azurepolicy.parameters.json' -Mode Indexed
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope>  -PolicyDefinition $definition
$assignment 
````

## Try with CLI

````cli
az policy definition create --name 'onboard-to-automation-dsc' --display-name 'Onboard Azure VM and Arc connected machines to Azure Automation DSC' --description 'Deploys the DSC extension to onboard nodes to Azure Automation DSC. Does not assign a configuration.' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Automation/onboard-to-automation-dsc/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Automation/onboard-to-automation-dsc/azurepolicy.parameters.json' --mode Indexed

az policy assignment create --name <assignmentname> --scope <scope> --policy "onboard-to-automation-dsc" 
````
