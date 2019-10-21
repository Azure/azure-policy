# Require Key Vault data plane access policies

Audits Key Vault vaults if their data plane access policies do not grant access to a specified AAD object. More information on Key Vault access management is available [here](https://docs.microsoft.com/en-us/azure/key-vault/key-vault-secure-your-key-vault).

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FKeyVault%2Frequire-keyvault-access-policies%2Fazurepolicy.json)
[![Deploy to Azure Gov](https://docs.microsoft.com/azure/governance/policy/media/deploy/deployGovbutton.png)](https://portal.azure.us/?#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FKeyVault%2Frequire-keyvault-access-policies%2Fazurepolicy.json)

## Try with PowerShell

````powershell
# Create the Policy Definition
$definition = New-AzPolicyDefinition -Name "require-keyvault-access-policies" -DisplayName "Audit when a given service principal is not assigned to the Key Vault data plane" -description "Audit when a specified AAD object is not granted permissions to secrets, certs, or keys stored in a Key Vault through data plane access policies. This policy will not validate the permissions granted by the access policy, only the existance of at least one access policy for that object." -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/KeyVault/require-keyvault-access-policies/azurepolicy.rules.json' -Mode All

# Show definition
$definition

# Create the Policy Assignment
$assignment = New-AzPolicyAssignment -Name "require-keyvault-access-policies" -Scope <scope> -PolicyDefinition $definition -aadObjectId f8efb48a-34e8-4ee6-b31f-133a05248f9c

# Show assignment
$assignment 
````

## Try with CLI

````cli
# Create the Policy Definition
az policy definition create --name 'require-keyvault-access-policies' --display-name 'Audit when a given service principal is not assigned to the Key Vault data plane' --description 'Audit when a specified AAD object is not granted permissions to secrets, certs, or keys stored in a Key Vault through data plane access policies. This policy will not validate the permissions granted by the access policy, only the existance of at least one access policy for that object.' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/KeyVault/require-keyvault-access-policies/azurepolicy.rules.json' --mode All

# Create the Policy Assignment
az policy assignment create --name 'require-keyvault-access-policies' --scope <scope> --policy 'require-keyvault-access-policies' --params "{'aadObjectId': {'value': 'f8efb48a-34e8-4ee6-b31f-133a05248f9c'}}"
````
