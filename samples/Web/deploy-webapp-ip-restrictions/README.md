# Deploy IP restrictions to a Web App

*Scenario*: You wish to apply a default set of IP restrictions to a Web App.

## Prerequisites
Before using modify the rule to include your IP addresses.  _They must be in CIDR format._

````json
    "ipSecurityRestrictions": [
        {
            "ipAddress": "1.1.1.1/32",
            "action": "Allow",
            "priority": 1110,
            "name": "Rule Name 1"
        },
        {
            "ipAddress": "2.2.2.2/32",
            "action": "Allow",
            "priority": 1111,
            "name": "Rule Name 2"
        }
    ]
````

## Notes
This is a deployIfNotExists policy; after deploying a Web App it may take several minutes for Azure Policy to execute the deployment.

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FWeb%2Fdeploy-webapp-ip-restrictions%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "deploy-webapp-ip-restrictions" -DisplayName "Web App default IP restrictions" -description "Deploy IP restrictions to a Web App" -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Web/deploy-webapp-ip-restrictions/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Web/deploy-webapp-ip-restrictions/azurepolicy.parameters.json' -Mode All
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope>  -PolicyDefinition $definition
$assignment 
````

## Try with CLI

````cli

az policy definition create --name 'deploy-webapp-ip-restrictions' --display-name 'Web App default IP restrictions' --description 'Deploy IP restrictions to a Web App' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Web/deploy-webapp-ip-restrictions/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Web/deploy-webapp-ip-restrictions/azurepolicy.parameters.json' --mode All

az policy assignment create --name <assignmentname> --scope <scope> --policy "deploy-webapp-ip-restrictions" 

````
