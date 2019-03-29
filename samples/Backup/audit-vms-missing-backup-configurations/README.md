# Audit VMs missing Backup Configurations

Audit the Vms which are missing the Backup configurations.

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FBackup%2Faudit-vms-missing-backup-configurations%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "audit-vms-missing-backup-configurations" -DisplayName "Audit VMs missing Backup Configurations" -description "Audit the VMs which are missing backup configurations in the environment" -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Backup/audit-vms-missing-backup-configurations/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Backup/audit-vms-missing-backup-configurations/azurepolicy.parameters.json' -Mode All
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope>  -PolicyDefinition $definition
$assignment 
````



## Try with CLI

````cli

az policy definition create --name 'audit-vms-missing-backup-configurations' --display-name 'Audit VMs missing Backup Configurations' --description 'Audit the VMs which are missing backup configurations in the environment' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Backup/audit-vms-missing-backup-configurations/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Backup/audit-vms-missing-backup-configurations/azurepolicy.parameters.json' --mode All

az policy assignment create --name <assignmentname> --scope <scope> --policy "audit-vms-missing-backup-configurations" 

````
