# Audit Resource Locks on Resource Groups based on Tags

Audits all Resource Groups that have a specific Tag, for the CanNotDelete Resource Lock.
Within this Policy, you specify the Tag Name and Tag Value that will be used for identifying the Resource Groups to audit.

## Try in the Azure Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FResourceGroup%2Faudit-resourceGroup-resourceLocks%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "audit-resourceGroup-resourceLocks" -DisplayName "Audit Resource Locks on Resource Groups based on Tags" -description "Audits all Resource Groups that have a specific Tag, for the CanNotDelete Resource Lock." -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/ResourceGroup/audit-resourceGroup-resourceLocks/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/ResourceGroup/audit-resourceGroup-resourceLocks/azurepolicy.parameters.json' -Mode All
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope> -tagName <tagName> -tagValue <tagValue> -PolicyDefinition $definition
$assignment 
````

## Try with CLI

````cli
az policy definition create --name 'audit-resourceGroup-resourceLocks' --display-name 'Audit Resource Locks on Resource Groups based on Tags' --description 'Audits all Resource Groups that have a specific Tag, for the CanNotDelete Resource Lock.' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/ResourceGroup/audit-resourceGroup-resourceLocks/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/ResourceGroup/audit-resourceGroup-resourceLocks/azurepolicy.parameters.json' --mode All

az policy assignment create --name <assignmentname> --scope <scope> --policy "audit-resourceGroup-resourceLocks" 
````
