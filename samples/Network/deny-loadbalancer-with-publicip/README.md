# Deny loadbalancers with public ip

This policy denies loadbalancer creation if loadbalancers use public ip.

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FNetwork%2Fdeny-loadbalancer-with-publicip%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "deny-loadbalancer-with-publicip" -DisplayName "Deny if loadbalancers exists with public ip" -description "This policy denies loadbalancer creation if loadbalancers use public ip." -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Network/deny-loadbalancer-with-publicip/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Network/deny-loadbalancer-with-publicip/azurepolicy.parameters.json' -Mode All
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope>  -location <location> -PolicyDefinition $definition
$assignment 
````



## Try with CLI

````cli

az policy definition create --name 'deny-loadbalancer-with-publicip' --display-name 'Audit if loadbalancers exists with public ip' --description 'This policy audits if loadbalancers exists with public ip.' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Network/deny-loadbalancer-with-publicip/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Network/deny-loadbalancer-with-publicip/azurepolicy.parameters.json' --mode All

az policy assignment create --name <assignmentname> --scope <scope> --policy "deny-loadbalancer-with-publicip" 

````
