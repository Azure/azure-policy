# Deploy default Log Analytics VM Extension for Windows VMs.

This policy deploys the Log Analytics VM Extensions on Windows VMs, and connects to the selected Log Analytics workspace.

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FCompute%2Fdeploy-oms-vm-extension-windows-vm%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "deploy-oms-vm-extension-windows-vm" -DisplayName "Deploy default Log Analytics VM Extension for Windows VMs." -description "This policy deploys the Log Analytics VM Extensions on Windows VMs, and connects to the selected Log Analytics workspace." -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Compute/deploy-oms-vm-extension-windows-vm/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Compute/deploy-oms-vm-extension-windows-vm/azurepolicy.parameters.json' -Mode Indexed
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope> -logAnalytics <logAnalytics> -PolicyDefinition $definition
$assignment 
````

## Try with CLI

````cli

az policy definition create --name 'deploy-oms-vm-extension-windows-vm' --display-name 'Deploy default Log Analytics VM Extension for Windows VMs.' --description 'This policy deploys the Log Analytics VM Extensions on Windows VMs, and connects to the selected Log Analytics workspace.' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Compute/deploy-oms-vm-extension-windows-vm/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Compute/deploy-oms-vm-extension-windows-vm/azurepolicy.parameters.json' --mode Indexed

az policy assignment create --name <assignmentname> --scope <scope> --params "{'logAnalytics':{'value': '<logAnalytics>'}}" --policy "deploy-oms-vm-extension-windows-vm" 

````
