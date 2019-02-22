# Deploy IP-Security-Restrictions

This policy allows you to configure IP addresses that are allowed to access your WebApps.


## Try with Azure portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FAppServices%2FWebApps%2Fdeploy-IP-security-restrictions%2Fazurepolicy.json)

## Try with Azure PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "deploy-webapp-IPsRestriction" -DisplayName "IPsRestriction for Azure WebApps" -description "This policy allows you to configure IP addresses that are allowed to access your WebApp." -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/App Service/WebApps/deploy-IP-security-restrictions/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/App Service/WebApps/deploy-IP-security-restrictions/azurepolicy.parameters.json' -Mode Indexed
$definition

$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope> -PolicyDefinition $definition -ipAddress <ipAddress> -action <action> -priority <priority> -rulename <rulename> -ruledescription <description> -AssignIdentity -location <e.g. West Europe>
$assignment
````

## Try with Azure CLI

````cli

az policy definition create --name 'deploy-webapp-IPsRestriction' --display-name 'IPsRestriction for Azure WebApps' --description 'This policy allows you to configure IP addresses that are allowed to access your WebApp.' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/App Service/WebApps/deploy-IP-security-restrictions/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/App Service/WebApps/deploy-IP-security-restrictions/azurepolicy.parameters.json' --mode Indexed

az policy assignment create --name '<assignmentname>' --scope '<scope>' --policy 'deploy-webapp-IPsRestriction' --params "{'ipAddress':{'value': '<CIDR>'},'action':{'value': '<action>'},'priority':{'value':'<priority>'},'rulename':{'value': '<rulename>'},'ruledescription':{'value': '<ruledescription>'}}" --assign-identity --location '<e.g. West Europe>'

````
