# Only allow certain image publishers from the Marketplace

Ensure that only the image publishers that you allow within your environment can be deployed

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/?feature.customportal=false&microsoft_azure_policy=true&microsoft_azure_policy_policyinsights=true&feature.microsoft_azure_security_policy=true&microsoft_azure_marketplace_policy=true#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fweeyin83%2Fazurepolicyexamples%2Fmaster%2FCompute%2Fallowed-image-publishers%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzureRmPolicyDefinition -Name "allowed-image-publishers-policy" -DisplayName "Only allow certain image publishers offerings to be deployed" -description "This policy ensures that only allowed image publisher offerings are selected from the image repository" -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Compute/allowed-image-publishers/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Compute/allowed-image-publishers/azurepolicy.parameters.json' -Mode All
$definition
$assignment = New-AzureRMPolicyAssignment -Name <assignmentname> -Scope <scope>  -PolicyDefinition $definition
$assignment
````

## Try with CLI

````cli

az policy definition create --name 'allowed-image-publishers-policy' --display-name 'Only allow certain image publishers offerings to be deployed' --description 'This policy ensures that only allowed image publisher offerings are selected from the image repository' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Compute/allowed-image-publishers/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Compute/allowed-image-publishers/azurepolicy.parameters.json' --mode All

az policy assignment create --name <assignmentname> --scope <scope> --policy "allowed-image-publishers-policy"

````

## Example number 1 with PowerShell

Apply scope to a single Resource Group

````powershell
#Define allowed publishers
$allowedpublishers = "Canonical", "MicrosoftWindowsServer", "RedHat"

#Define ResourceGroup Policy will be applied to
$ResourceGroup = Get-AzureRMResourceGroup -Name "ResourceGroup1"

#Setup Policy Defintion
$definition = New-AzureRmPolicyDefinition -Name "allowed-image-publishers-policy" -DisplayName "Allowed image publishers only" -description "This policy ensures that only allowed image publisher offerings are selected from the image repository" -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Compute/allowed-image-publishers/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Compute/allowed-image-publishers/azurepolicy.parameters.json' -Mode All
$definition

#Create Policy assignment using the new definition
$assignment = New-AzureRMPolicyAssignment -Name "Canonical-RedHat-WindowsServer-only-policy" -Scope $ResourceGroup.ResourceId -sku @{"Name" = "A1"; "Tier" = "Standard"} -listOfAllowedimagePublisher $allowedpublishers -PolicyDefinition $definition
$assignment
````

## Example number 2 with PowerShell

Apply policy to an entire subscription.

````powershell
#Define allowed publishers
$allowedpublishers = "Canonical", "MicrosoftWindowsServer", "RedHat"

#Define Subscription Policy will be applied to
$Subscription = Get-AzureRMSubscription -SubscriptionName "Production"

#Setup Policy Defintion
$definition = New-AzureRmPolicyDefinition -Name "allowed-image-publishers-policy" -DisplayName "Allowed image publishers only" -description "This policy ensures that only allowed image publisher offerings are selected from the image repository" -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Compute/allowed-image-publishers/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Compute/allowed-image-publishers/azurepolicy.parameters.json' -Mode All
$definition

#Create Policy assignment using the new definition
$assignment = New-AzureRMPolicyAssignment -Name "Canonical-RedHat-WindowsServer-only-policy" -Scope "/subscriptions/$subscription" -sku @{"Name" = "A1"; "Tier" = "Standard"} -listOfAllowedimagePublisher $allowedpublishers -PolicyDefinition $definition
$assignment
````

## Example number 3 with CLI

````cli

az policy definition create --name 'allowed-image-publishers-policy' --display-name 'Allowed image publishers only' --description 'This policy ensures that only allowed image publisher offerings are selected from the image repository.' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Compute/allowed-image-publishers/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Compute/allowed-image-publishers/azurepolicy.parameters.json' --mode Indexed

az policy assignment create --name <assignmentname> --scope <scope> --policy "allowed-image-publishers-policy" --params '{"listOfAllowedimagePublisher":{"value": [ 'redhat', 'MicrosoftWindowsServer']}}'

````