# Audit unrestricted network access to storage accounts

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/?feature.customportal=false&microsoft_azure_policy=true&microsoft_azure_policy_policyinsights=true&feature.microsoft_azure_security_policy=true&microsoft_azure_marketplace_policy=true#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2Fbuilt-in-policy%2Faudit-unrestriced-network-access-to-storage-accounts%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzureRmPolicyDefinition -Name "Audit unrestriced network access to storage acounts" -DisplayName "Audit unrestriced network access to storage acounts" -description "Audit unrestricted network access in your storage account firewall settings. Instead, configure network rules so only applications from allowed networks can access the storage account. To allow connections from specific internet or on-premise clients, access can be granted to traffic from specific Azure virtual networks or to public internet IP address ranges" -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/built-in-policy/audit-unrestriced-network-access-to-storage-accounts/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/built-in-policy/audit-unrestriced-network-access-to-storage-accounts/azurepolicy.parameters.json' -Mode All
$definition
$assignment = New-AzureRMPolicyAssignment -Name <assignmentname> -Scope <scope> -PolicyDefinition $definition
$assignment
''''

## Try with CLI

````cli
az policy definition create --name 'Audit unrestriced network access to storage acounts' --display-name 'Audit unrestriced network access to storage acounts' --description 'Audit unrestricted network access in your storage account firewall settings. Instead, configure network rules so only applications from allowed networks can access the storage account. To allow connections from specific internet or on-premise clients, access can be granted to traffic from specific Azure virtual networks or to public internet IP address ranges' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/built-in-policy/audit-unrestriced-network-access-to-storage-accounts/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/built-in-policy/audit-unrestriced-network-access-to-storage-accounts/azurepolicy.parameters.json' --mode All

az policy assignment create --name <assignmentname> --scope <scope> --policy "Audit unrestriced network access to storage acounts" 
````