# {{displayName}}

{{description}}

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://aka.ms/getpolicy)

## Try with PowerShell

````powershell
$policydefinitions = "https://raw.githubusercontent.com/Azure/azure-policy-samples/master/samples/{{path}}/azurepolicyset.definitions.json"
$policysetparameters = "https://raw.githubusercontent.com/Azure/azure-policy-samples/master/samples/{{path}}/azurepolicyset.parameters.json"

$policyset= New-AzureRmPolicySetDefinition -Name "{{policyName}}" -DisplayName "{{displayName}}" -Description "{{description}}" -PolicyDefinition $policydefinitions -Parameter $policysetparameters 
 
New-AzureRmPolicyAssignment -PolicySetDefinition $policyset -Name <assignmentname> -Scope <scope> {{parameters}}  -Sku @{"Name"="A1";"Tier"="Standard"}
````

## Try with CLI

````

CLI for policy set is not supported yet

````
