# Only allow a certain VM platform images

This policy ensures that only certain VM platform images are allowed from the image repository

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/?feature.customportal=false&microsoft_azure_policy=true&microsoft_azure_policy_policyinsights=true&feature.microsoft_azure_security_policy=true&microsoft_azure_marketplace_policy=true#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FCompute%2Fallowed-platform-images%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzureRmPolicyDefinition -Name "allowed-platform-images" -DisplayName "Only allow a certain VM platform images" -description "This policy ensures that only certain VM platform images are allowed from the image repository" -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Compute/allowed-platform-images/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Compute/allowed-platform-images/azurepolicy.parameters.json' -Mode All
$definition
$assignment = New-AzureRMPolicyAssignment -Name <assignmentname> -Scope <scope> -allowedImagePublishers '["Canonical"]' -allowedImageOffers '["UbuntuServer"]' -allowedImageSkus '["14.04.2-LTS", "18.04 LTS"]' -PolicyDefinition $definition
$assignment 
````

## Try with CLI

````cli

az policy definition create --name 'allowed-platform-images' --display-name 'Only allow a certain VM platform images' --description 'This policy ensures that only certain VM platform images are allowed from the image repository' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Compute/allowed-platform-images/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Compute/allowed-platform-images/azurepolicy.parameters.json' --mode All

az policy assignment create --name <assignmentname> --scope <scope> --params "{ 'allowedImagePublishers': { 'value': '["Canonical"]'}, 'allowedImageOffers': { 'value': '["UbuntuServer"]'}, 'allowedImageSkus': { 'value': '["14.04.2-LTS", "18.04 LTS"]'} }" --policy "allowed-platform-images" 

````