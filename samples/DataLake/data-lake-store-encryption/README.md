# Enforce encryption on Data Lake Store accounts

This policy ensures encryption is enabled on all Data Lake Store accounts

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FDataLake%2Fdata-lake-store-encryption%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "data-lake-store-encryption" -DisplayName "Enforce encryption on Data Lake Store accounts" -description "This policy ensures encryption is enabled on all Data Lake Store accounts" -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/DataLake/data-lake-store-encryption/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/DataLake/data-lake-store-encryption/azurepolicy.parameters.json' -Mode Indexed
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope> -PolicyDefinition $definition
$assignment 
````

## Try with CLI

````cli

az policy definition create --name 'data-lake-store-encryption' --display-name 'Enforce encryption on Data Lake Store accounts' --description 'This policy ensures encryption is enabled on all Data Lake Store accounts' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/DataLake/data-lake-store-encryption/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/DataLake/data-lake-store-encryption/azurepolicy.parameters.json' --mode Indexed

az policy assignment create --name <assignmentname> --scope <scope> --policy "data-lake-store-encryption" 

````
