# Audit loadbalancers with public ip

This policy audits if loadbalancers exists with public ip.

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FNetwork%2Faudit-loadbalancers-with-publicip%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "audit-loadbalancers-with-publicip" -DisplayName "Audit if loadbalancers exists with public ip" -description "This policy audits if loadbalancers exists with public ip." -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Network/audit-loadbalancers-with-publicip/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Network/audit-loadbalancers-with-publicip/azurepolicy.parameters.json' -Mode All
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope>  -location <location> -PolicyDefinition $definition
$assignment 
````



## Try with CLI

````cli

az policy definition create --name 'audit-loadbalancers-with-publicip' --display-name 'Audit if loadbalancers exists with public ip' --description 'This policy audits if loadbalancers exists with public ip.' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Network/audit-loadbalancers-with-publicip/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Network/audit-loadbalancers-with-publicip/azurepolicy.parameters.json' --mode All

az policy assignment create --name <assignmentname> --scope <scope> --policy "audit-loadbalancers-with-publicip" 

````
