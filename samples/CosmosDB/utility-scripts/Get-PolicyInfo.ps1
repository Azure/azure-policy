$subscriptionId = (Get-AzContext).Subscription.Id

# Get custom policy definitions
$definitions = Get-AzPolicyDefinition -SubscriptionId $subscriptionId -Custom
# $definitions

# Get policy state summary for each custom policy definition
ForEach ($definition in $definitions) {
	Write-Host "Policy State Summary"
	Get-AzPolicyStateSummary -SubscriptionId $subscriptionId -PolicyDefinitionName $definition.Name

	Write-Host "Policy Assignments"
	$assignments = Get-AzPolicyAssignment -PolicyDefinitionId $definition.PolicyDefinitionId

	ForEach ($assignment in $assignments) {
		Write-Host "Policy State for the Policy Assignment"
		Get-AzPolicyState -SubscriptionId $subscriptionId -PolicyAssignmentName $assignment.Name
		Write-Host ""
	}
}


