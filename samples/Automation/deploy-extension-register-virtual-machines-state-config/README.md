# Deploy extension to register virtual machines to Azure State Configuration

When virtual machines are deployed, automatically register them to be managed by Azure State Configuration.

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FAutomation%2Fdeploy-extension-register-virtual-machines-state-config%2Fazurepolicy.json)

## Try with Powershell

````powershell
$definition = New-AzPolicyDefinition -Name "deploy-extension-register-virtual-machines-state-config" -DisplayName "Deploy extension to register virtual machines to Azure State Configuration" -description "When virtual machines are deployed, automatically register them to be managed by Azure State Configuration." -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Automation/deploy-extension-register-virtual-machines-state-config/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Automation/deploy-extension-register-virtual-machines-state-config/azurepolicy.parameters.json' -Mode All
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope>  -PolicyDefinition $definition
$assignment 
````

## Try with CLI

````cli
az policy definition create --name 'deploy-extension-register-virtual-machines-state-config' --display-name 'Audit encryption of Automation account variables' --description 'It is important to enable encryption of Automation account variable assets when storing sensitive data.' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Automation/deploy-extension-register-virtual-machines-state-config/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Automation/deploy-extension-register-virtual-machines-state-config/azurepolicy.parameters.json' --mode All

az policy assignment create --name <assignmentname> --scope <scope> --policy "deploy-extension-register-virtual-machines-state-config" 
````
