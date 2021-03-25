# Ensure that HDInsight Clusters are deployed using the VNet from the subscription 

By default, HDInsight Clusters are deployed to use a VNet shared by other customers, which prevents securing access to the Clusters with Network Configuration (NSGs, Routing, VPN's ASC JIT, Azure Firewall, Etc).  This policy is to require that users deploy HDInsight Clusters using the Advanced Configuration Option of using a Virtual Network inside of the users subscription, therefore limiting network access to the cluster to the users subscription configuration.

## Try on Portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-policy%2Fmaster%2Fsamples%2FNetwork%2Fhdinsight-require-subscription-vnet%2Fazurepolicy.json)

## Try with PowerShell

````powershell
$definition = New-AzPolicyDefinition -Name "deploy-network-watcher-when-virtual-network-created" -DisplayName "Deploy HDInsight Cluster with Subscription's VNet" -description "This policy enforces use of subscription's virtual network when creating HDInsight Clusters, allowing securing network level access to the HDInsight Cluster." -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Network/hdinsight-require-subscription-vnet/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Network/hdinsight-require-subscription-vnet/azurepolicy.parameters.json' -Mode Indexed
$definition
$assignment = New-AzPolicyAssignment -Name <assignmentname> -Scope <scope> -PolicyDefinition $definition -effect <Effect>
$assignment 
````

## Try with CLI

````cli

az policy definition create --name 'hdinsight-require-subscription-vnet' --display-name 'Deploy HDInsigth Cluster with Subscription's VNet' --description 'This policy enforces use of subscription's virtual network when creating HDInsight Clusters, allowing securing network level access to the HDInsight Cluster.' --rules 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/hdinsight-require-subscription-vnet/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Network/hdinsight-require-subscription-vnet/azurepolicy.parameters.json' --mode Indexed

az policy assignment create --name <assignmentname> --scope <scope> --policy "hdinsight-require-subscription-vnet" --effect <effect>

````
