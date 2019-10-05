# Enforce Admin User is disabled on all Container Registry instances

This policy ensures Admin User is disabled on all Container Registry instances

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FContainerRegistry%2Fcontainer-registry-admin-user-filter%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "container-registry-admin-user-filter" -DisplayName "Enforce Admin User is disabled on all Container Registry instances" -description "This policy ensures Admin User is disabled on all Container Registry instances" -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/ContainerRegistry/container-registry-admin-user-filter/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/ContainerRegistry/container-registry-admin-user-filter/azurepolicy.parameters.json' -Mode Indexed
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope> -PolicyDefinition $definition
$assignment
````

## Try with CLI

````cli

az policy definition create --name 'container-registry-admin-user-filter' --display-name 'Enforce Admin User is disabled on all Container Registry instances' --description 'This policy ensures Admin User is disabled on all Container Registry instances' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/ContainerRegistry/container-registry-admin-user-filter/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/ContainerRegistry/container-registry-admin-user-filter/azurepolicy.parameters.json' --mode Indexed

az policy assignment create --name <assignmentname> --scope <scope> --policy "container-registry-admin-user-filter" 

````
