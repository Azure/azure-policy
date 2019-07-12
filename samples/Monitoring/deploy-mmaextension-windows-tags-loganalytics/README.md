# Deploy Microsoft Monitoring Agent on Windows Machines based on a Tag

Deploy Microsoft Monitoring Agent/Extension on Azure Virtual Machines with Windows OS and a Tag.

TAG DETAILS
Name: Windows
Value : MMA

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FMonitoring%2Fdeploy-mmaextension-windows-tags-loganalytics%2Fazurepolicy.json)

## Try with PowerShell

```powershell
$definition = New-AzPolicyDefinition -Name "Deploy-mmaextension-windows-tags-loganalytics" -DisplayName "Deploy Microsoft Monitoring Agent on Windows Machines based on a Tag" -description "Deploy Microsoft Monitoring Agent on Windows Machines based on a Tag with value: MMA and Name: Windows" -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Monitoring/deploy-mmaextension-windows-tags-loganalytics/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Monitoring/deploy-mmaextension-windows-tags-loganalytics/azurepolicy.parameters.json' -Mode Indexed
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope> -metricName <metricName> -PolicyDefinition $definition
$assignment
```

## Try with CLI

```cli

az policy definition create --name 'Deploy-mmaextension-windows-tags-loganalytics' --display-name 'Deploy Microsoft Monitoring Agent on Windows Machines based on a Tag' --description 'Deploy Microsoft Monitoring Agent on Windows Machines based on a Tag' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Monitoring/deploy-mmaextension-windows-tags-loganalytics/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Monitoring/deploy-mmaextension-windows-tags-loganalytics/azurepolicy.parameters.json' --mode Indexed

az policy assignment create --name <assignmentname> --scope <scope> --params "{'metricName':{'value':'<metricName>'}}" --policy "deploy-mmaextension-windows-tags-loganalytics"

```
