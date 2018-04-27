# [Preview]: Deploy Auditing on SQL servers

This policy ensures that Auditing is enabled on SQL Servers for enhanced security & compliance. It will automatically create a storage account in the same region as the SQL server to store audit records.

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/?feature.customportal=false&microsoft_azure_policy=true&microsoft_azure_policy_policyinsights=true&feature.microsoft_azure_security_policy=true&microsoft_azure_marketplace_policy=true#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FSQL%2Fdeploy-sql-server-auditing%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzureRmPolicyDefinition -Name "deploy-sql-server-auditing" -DisplayName "[Preview]: Deploy Auditing on SQL servers" -description "This policy ensures that Auditing is enabled on SQL Servers for enhanced security & compliance. It will automatically create a storage account in the same region as the SQL server to store audit records." -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/SQL/deploysql-server-auditing/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/SQL/deploy-sql-server-auditing/azurepolicy.parameters.json' -Mode Indexed
$definition
$assignment = New-AzureRMPolicyAssignment -Name <assignmentname> -Scope <scope> -storageAccountsResourceGroup <resourceGroupName> -PolicyDefinition $definition
$assignment
````



## Try with CLI

````cli

az policy definition create --name 'deploy-sql-server-auditing' --display-name '[Preview]: Deploy Auditing on SQL servers' --description 'This policy ensures that Auditing is enabled on SQL Servers for enhanced security & compliance. It will automatically create a storage account in the same region as the SQL server to store audit records.' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/SQL/deploy-sql-server-auditing/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/SQL/deploy-sql-server-auditing/azurepolicy.parameters.json' --mode Indexed

az policy assignment create --name <assignmentname> --scope <scope> --policy "deploy-sql-server-auditing" --params '{ "storageAccountResourceGroup": { "value": "myResourceGroup" } }'

````
