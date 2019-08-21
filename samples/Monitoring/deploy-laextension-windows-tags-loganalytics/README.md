# Deploy Log Analytics Agent on Windows Machines based on a Tag

Deploy Log Analytics Agent/Extension on Azure Virtual Machines with Windows OS and a Tag.

TAG Example:
Name: Windows
Value : LA

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FMonitoring%2Fdeploy-laextension-windows-tags-loganalytics%2Fazurepolicy.json)

## Try with PowerShell

```powershell
$definition = New-AzPolicyDefinition -Name "Deploy-laextension-windows-tags-loganalytics" -DisplayName "Deploy Log Analytics Agent on Windows Machines based on a Tag" -description "Deploy Log Analytics Agent on Windows Machines based on a Tag provided in the Input" -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Monitoring/deploy-laextension-windows-tags-loganalytics/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Monitoring/deploy-laextension-windows-tags-loganalytics/azurepolicy.parameters.json' -Mode Indexed
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope> -logAnalytics <logAnalytics> -tagName <tagName> -tagValue <tagValue> -PolicyDefinition $definition
$assignment
```

## Try with CLI

```cli

az policy definition create --name 'Deploy-laextension-windows-tags-loganalytics' --display-name 'Deploy Log Analytics Agent on Windows Machines based on a Tag' --description 'Deploy Log Analytics Agent on Windows Machines based on a Tag' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Monitoring/deploy-laaextension-windows-tags-loganalytics/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Monitoring/deploy-laextension-windows-tags-loganalytics/azurepolicy.parameters.json' --mode Indexed

az policy assignment create --name <assignmentname> --scope <scope> --params "{'logAnalytics':{'value':'<logAnalytics>'},'tagName':{'value':'<tagName>'},'tagValue':{'value':'<tagValue>'}}" --policy "deploy-laaextension-windows-tags-loganalytics"

```
