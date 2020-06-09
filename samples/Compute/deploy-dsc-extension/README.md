## Deploy DSC Extension to Azure VM and Arc connected machines

Deploys the DSC extension to and assigns configuration artifact from url location.

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FCompute%2Fdeploy-dsc-extension%2Fazurepolicy.json)

## Try with Powershell

````powershell
$definition = New-AzPolicyDefinition -Name "deploy-dsc-extension" -DisplayName "Deploy DSC Extension to Azure VM and Arc connected machines" -description "Deploys the DSC extension to and assigns configuration artifact from url location." -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Compute/deploy-dsc-extension/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Compute/deploy-dsc-extension/azurepolicy.parameters.json' -Mode Indexed
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope>  -PolicyDefinition $definition
$assignment 
````

## Try with CLI

````cli
az policy definition create --name 'deploy-dsc-extension' --display-name 'Deploy DSC Extension to Azure VM and Arc connected machines' --description 'Deploys the DSC extension to and assigns configuration artifact from url location.' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Compute/deploy-dsc-extension/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Compute/deploy-dsc-extension/azurepolicy.parameters.json' --mode Indexed

az policy assignment create --name <assignmentname> --scope <scope> --policy "deploy-dsc-extension" 
````
