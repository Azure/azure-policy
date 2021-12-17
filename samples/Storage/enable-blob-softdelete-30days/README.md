# Enable Blob Soft delete to specific numbers of days

This policy checks if soft delete is enabled and set to the specified numbers of days (30 by default), if not it update the retention policy accordingly

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FStorage%2Fenable-blob-softdelete-30days%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "https-traffic-only" -DisplayName "Enable Blob Soft delete to specific numbers of days" -description "This policy checks if soft delete is enabled and set to the specified numbers of days (30 by default), if not it update the retention policy accordingly" -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Storage/enable-blob-softdelete-30days/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Storage/enable-blob-softdelete-30days/azurepolicy.parameters.json' -Mode All
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope>  -PolicyDefinition $definition
$assignment 
````



## Try with CLI

````cli

az policy definition create --name 'enable-blob-softdelete-30days' --display-name 'Enable Blob Soft delete to specific numbers of days' --description 'Ensure https traffic only for storage account' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Storage/enable-blob-softdelete-30days/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Storage/enable-blob-softdelete-30days/azurepolicy.parameters.json' --mode All

az policy assignment create --name <assignmentname> --scope <scope> --policy "enable-blob-softdelete-30days" 

````
