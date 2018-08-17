# [Preview]: Deploy default OMS VM Extension for Windows VMs.

This policy deploys OMS VM Extensions on Windows VMs, and connects to the selected Log Analytics workspace

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/?feature.customportal=false&microsoft_azure_policy=true&microsoft_azure_policy_policyinsights=true&feature.microsoft_azure_security_policy=true&microsoft_azure_marketplace_policy=true#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2Fbuilt-in-policy%2Fdeploy-oms-vm-extention-windows-vm%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzureRmPolicyDefinition -Name "deploy-oms-vm-extention-windows-vm" -DisplayName "[Preview]: Deploy default OMS VM Extension for Windows VMs." -description "This policy deploys OMS VM Extensions on Windows VMs, and connects to the selected Log Analytics workspace" -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/built-in-policy/deploy-oms-vm-extention-windows-vm/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/built-in-policy/deploy-oms-vm-extention-windows-vm/azurepolicy.parameters.json' -Mode Indexed
$definition
$assignment = New-AzureRMPolicyAssignment -Name <assignmentname> -Scope <scope> -logAnalytics <logAnalytics> -PolicyDefinition $definition
$assignment 
````

## Try with CLI

````cli

az policy definition create --name 'deploy-oms-vm-extention-windows-vm' --display-name '[Preview]: Deploy default OMS VM Extension for Windows VMs.' --description 'This policy deploys OMS VM Extensions on Windows VMs, and connects to the selected Log Analytics workspace' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/built-in-policy/deploy-oms-vm-extention-windows-vm/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/built-in-policy/deploy-oms-vm-extention-windows-vm/azurepolicy.parameters.json' --mode Indexed

az policy assignment create --name <assignmentname> --scope <scope> --policy "deploy-oms-vm-extention-windows-vm" 

````
