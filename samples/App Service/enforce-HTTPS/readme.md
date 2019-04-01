# Deploy HTTPS-Only for App Services

Ensure https traffic only for App Services e.g. WebApps / Function Apps / API Apps.


## Try with Azure portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FAppServices%2Fenforce-HTTPS%2Fazurepolicy.json)

## Try with Azure PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "https-traffic-only" -DisplayName "Ensure https traffic only for App Services" -description "Ensure https traffic only for App Services e.g. WebApps / Function Apps / API Apps." -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/App Service/enforce-HTTPS/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/App Service/enforce-HTTPS/azurepolicy.parameters.json' -Mode all
$definition

$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope>  -PolicyDefinition $definition
$assignment 
````

## Try with Azure CLI

````cli

az policy definition create --name 'https-traffic-only' --display-name 'HTTPS only for App Services' --description 'Ensure https traffic only for App Services e.g. WebApps / Function Apps / API Apps.' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/App Service/enforce-HTTPS/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/App Service/enforce-HTTPS/azurepolicy.parameters.json' --mode all

az policy assignment create --name <assignmentname> --scope <scope> --policy "https-traffic-only" 
````
