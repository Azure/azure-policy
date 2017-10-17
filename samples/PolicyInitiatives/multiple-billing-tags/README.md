# Billing Tags Policy Initiative

Specify cost Center tag and product name tag

## Deploy Policy to Azure

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://aka.ms/getpolicy)

## Try with PowerShell

````
$policydefinitions = "https://raw.githubusercontent.com/Azure/azure-policy-samples/master/samples/PolicyInitiative/multiple-billing-tags/azurepolicyset.definitions.json"
$policysetparameters = "https://raw.githubusercontent.com/Azure/azure-policy-samples/master/samples/PolicyInitiative/multiple-billing-tags/azurepolicyset.parameters.json"

$policyset= New-AzureRmPolicySetDefinition -Name BillingTags -PolicyDefinition $policydefinitions -Parameter $policysetparameters -Description "Specify cost Center tag and product name tag" -DisplayName "Billing Tags Policy"

New-AzureRmPolicyAssignment -PolicySetDefinition $policyset -DisplayName "Ensure All Billing Tags" -Name "all-billing-tags" -costCenterValue "00001" -productNameValue "contoso.com" -Scope "/subscriptions/######"  -Sku @{"Name"="A1";"Tier"="Standard"}

````

## Try with CLI

````

CLI for policy set is not supported yet

````


