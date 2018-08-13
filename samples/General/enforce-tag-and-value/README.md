## Deny for tags and their values
Enforces a required tag and its value. Does not apply to resource groups.



## Try with PowerShell
````powershell
$rg = Get-AzureRmResourceGroup -Name 'PriyaTestGroup'

$definition = Get-AzureRmPolicyDefinition | Where-Object { $_.Properties.DisplayName -eq 'Enforce tag and its value' }

New-AzureRmPolicyAssignment -Name 'enforce-required-tag' -DisplayName 'Enforces a required tag and its value' -scope '/subscriptions/d0610b27-9663-4c05-89f8-5b4be01e86a5/resourceGroups/PriyaTestGroup' -PolicyDefinition $definition
....



## Try with CLI
````cli
az policy definition create --name 'enforce-tag-and-value' --display-name 'Deny for tag and value' --description 'enforce tag' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/General/audit-allowed-locations/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/General/audit-allowed-locations/azurepolicy.parameters.json' --mode Indexed

az policy assignment create --name <assignmentname> --scope <scope> --policy "enforce-tag-and-value" --params '{"tagName":"tagValue"}'
....