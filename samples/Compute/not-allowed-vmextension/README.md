# Govern VM Extensions

This policy controls which VM extensions that are not allowed at the preferred scope.

## Deploy Policy to Azure

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fazure%2Fazure-policy-samples%2Fmaster%2Fcompute%2Fnot-allowed-vmextension%2Fazurepolicy.json)

## How to create Policy Definition using PowerShell

````
$definition = New-AzureRmPolicyDefinition -Name restrictExtensions `
                                          -DisplayName extenstionrestrictions `
                                          -PolicyUri 'github.com/raw/foo/azurepolicy.rules.json' `
                                          -ParameterUri 'github.com/raw/bar/azurepolicy.parameters.json'
````

## How to create Policy Assignment using PowerShell

````
$deniedExtensions = @("BGInfo", "VMAccess")
$policyParams = @{"notAllowedExtensions"="$deniedExtensions}

$New-AzureRmPolicyAssignment -Name restrictExtensions `
                             -Scope <sub or rg id> `
                             -PolicyDefinition $definition `
                             -PolicyParameterObject $policyParams
````
## How to create Policy Definitions using AzureCLI

````

Az policy definition create –name restrictExtension –policyUri 'github.com/raw/foo/azurepolicy.rules.json' – parametersUri 'github.com/raw/bar/azurepolicy.parameters.json'

````

## How to create Policy Assignment using AzureCLI

````

Az policy assignment create –policy <policyId> --name restrictExtension –scope <scope> --parameters $params

````
