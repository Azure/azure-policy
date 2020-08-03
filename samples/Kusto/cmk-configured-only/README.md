# Audit customer managed key encryption for Azure Data Explorer (kusto)

Audit customer managed key encryption for Azure Data Explorer (kusto)

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FKusto%2Fcmk-configured-only%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "audit-kusto-cmk-encryption" -DisplayName "Audit Azure Data Explorer Customer Managed Key Encryption" -description "This policy audits that Azure Data Explorer Cluster are encrypting the data using customer managed keys." -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Kusto/cmk-configured-only/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Kusto/cmk-configured-only/azurepolicy.parameters.json' -Mode All
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope>  -PolicyDefinition $definition
$assignment 
````



## Try with CLI

````cli

az policy definition create --name 'audit-kusto-cmk-encryption' --display-name 'Audit Azure Data Explorer Customer Managed Key Encryption' --description 'This policy audits that Azure Data Explorer Cluster are encrypting the data using customer managed keys.' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Kusto/cmk-configured-only/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Kusto/cmk-configured-only/azurepolicy.parameters.json' --mode All

az policy assignment create --name <assignmentname> --scope <scope> --policy "audit-kusto-cmk-encryption" 

````
