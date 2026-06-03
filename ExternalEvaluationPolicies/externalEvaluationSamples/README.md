## External Evaluation feature
Azure Policy’s external evaluation feature enables policy authors to make enforcement decisions based on context outside of the resource request.  The sample policy definitions in this repository illustrate how to use Azure Resource Graph as an external evaluator.

### Policy definition samples
_Note: the repository of sample definitions will slowly grow over time._

| Sample | Description |
|--------|-------------|
| 'Subnets should not be shared' | Denies a subnet from being associated with a network security group (NSG) that is already shared with other subnets. An Azure Resource Graph query checks how many other subnets are linked to the NSG, and the policy denies the assignment if one or more are found. |
| 'Enforce on new storage accounts only' | Denies the creation of new storage accounts that have public network access enabled, while excluding pre-existing storage accounts from enforcement. An Azure Resource Graph query determines whether the storage account already exists and passes the result back to the policy as a claim. |

### How to get started
The feature is currently in preview. To be a part of the preview, please create a GitHub issue with the title 'Requesting onboarding to external evaluation feature', and a member of our team will follow-up.


