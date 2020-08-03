# Ensure disk encryption enabled for Azure Data Explorer (kusto)

Ensure disk encryption enabled for Azure Data Explorer (kusto)

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FKusto%2Fencrypted-disk-only%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "audit-kusto-disk-encryption" -DisplayName "Audit Azure Data Explorer Disk Encryption" -description "This policy ensures that Azure Data Explorer Cluster have disc encryption enabled." -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Kusto/encrypted-disk-only/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Kusto/encrypted-disk-only/azurepolicy.parameters.json' -Mode All
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope>  -PolicyDefinition $definition
$assignment 
````



## Try with CLI

````cli

az policy definition create --name 'audit-kusto-disk-encryption' --display-name 'Audit Azure Data Explorer Disk Encryption' --description 'This policy ensures that Azure Data Explorer Cluster have disc encryption enabled.' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Kusto/encrypted-disk-only/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Kusto/encrypted-disk-only/azurepolicy.parameters.json' --mode All

az policy assignment create --name <assignmentname> --scope <scope> --policy "audit-kusto-disk-encryption" 

````
