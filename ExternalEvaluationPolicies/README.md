## External Evaluation feature
Azure Policy’s external evaluation feature enables policy authors to make enforcement decisions based on context outside of the resource request.  The sample policy definitions in this repository are intended to help you get started quickly with working examples that demonstrate how to use the feature.

### Policy definition samples
_Note: the repository of sample definitions will slowly grow over time._

| Sample | Description |
|--------|-------------|
| 'Subnets should not be shared' | Denies a subnet from being associated with a network security group (NSG) that is already shared with other subnets. An Azure Resource Graph query checks how many other subnets are associated with the same NSG and denies the request if any exist. |
| 'Enforce on new storage accounts only' | Denies the creation of new storage accounts that have public network access enabled, while excluding pre-existing storage accounts from enforcement. An Azure Resource Graph query checks whether the resource already exists in ARG and only applies the deny effect if it does not.  Note that this ARG query can be utilized for other scenarios where enforcement should be scoped to new resources only. |

### How to get started
The feature is currently in preview. To be a part of the preview, please create a GitHub issue with the title 'Requesting onboarding to external evaluation feature', and a member of our team will reach out to you.
