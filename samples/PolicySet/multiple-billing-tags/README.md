# Policy Set

This policy set enforces two billing tags and the values for cost center and product name.

## Deploy Policy to Azure

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://aka.ms/getpolicy)

## How to create Policy Set Definition using PowerShell

````
$policydefinitions = "https://raw.githubusercontent.com/Azure/azure-policy-samples/master/samples/PolicySet/multiple-billing-tags/azurepolicyset.definitions.json"
$policysetparameters = "https://raw.githubusercontent.com/Azure/azure-policy-samples/master/samples/PolicySet/multiple-billing-tags/azurepolicyset.parameters.json"

$policyset= New-AzureRmPolicySetDefinition -Name BillingTags -PolicyDefinition $policydefinitions -Parameter $policysetparameters -Description "Specify cost Center tag and product name tag" -DisplayName "Billing Tags Policy"
 
New-AzureRmPolicyAssignment -PolicySetDefinition $policyset -DisplayName "Ensure All Billing Tags" -Name "all-billing-tags" -costCenterValue "00001" -productNameValue "contoso.com" -Scope "/subscriptions/######"  -Sku @{"Name"="A1";"Tier"="Standard"}

````

## How to create Policy Assignment using PowerShell

````
New-AzureRmPolicyAssignment -PolicySetDefinition $policyset -DisplayName "Ensure All Billing Tags" -Name "all-billing-tags" -costCenterValue "00001" -productNameValue "contoso.com" -Scope "/subscriptions/######"  -Sku @{"Name"="A1";"Tier"="Standard"}
````
## How to create Policy Definitions using AzureCLI

````

CLI for policy set is not supported yet

````

## How to create Policy Assignment using AzureCLI

````

CLI for policy set is not supported yet

````
