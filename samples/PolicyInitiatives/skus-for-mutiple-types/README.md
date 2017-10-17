# Allowed SKUs for Storage Accounts and Virtual Machines

This policy allows you to speficy what skus are allowed for storage accounts and virtual machines

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://aka.ms/getpolicy)

## Try with PowerShell

````powershell
$policydefinitions = "https://raw.githubusercontent.com/Azure/azure-policy-samples/master/samples/PolicyInitiatives/skus-for-mutiple-types/azurepolicyset.definitions.json"
$policysetparameters = "https://raw.githubusercontent.com/Azure/azure-policy-samples/master/samples/PolicyInitiatives/skus-for-mutiple-types/azurepolicyset.parameters.json"

$policyset= New-AzureRmPolicySetDefinition -Name "skus-for-mutiple-types" -DisplayName "Allowed SKUs for Storage Accounts and Virtual Machines" -Description "This policy allows you to speficy what skus are allowed for storage accounts and virtual machines" -PolicyDefinition $policydefinitions -Parameter $policysetparameters 
 
New-AzureRmPolicyAssignment -PolicySetDefinition $policyset -Name <assignmentname> -Scope <scope>  -LISTOFALLOWEDSKUS_1 <VM SKUs> -LISTOFALLOWEDSKUS_2 <Storage Account SKUs >  -Sku @{"Name"="A1";"Tier"="Standard"}
````

## Try with CLI

````

CLI for policy set is not supported yet

````
