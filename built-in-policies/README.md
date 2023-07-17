# Built-in Azure Policies

This folder contains a read-only set all of the built-in policy definitions and initiatives (a.k.a policySetDefinitions) available in Azure's public cloud. They are organized into folders by category.

Starting in January 2020, this repo will be updated each time changes are deployed to Azure. Such updates to built-in definitions are necessary to ensure that policy definition logic remains up-to-date and compliance results are accurate to what the user expects. 

You can view the commit history for each policy to see changes over time. You can [subscribe to get these notifications](https://docs.github.com/account-and-profile/managing-subscriptions-and-notifications-on-github/setting-up-notifications/configuring-notifications#configuring-your-watch-settings-for-an-individual-repository). There is also an [atom feed](https://github.com/Azure/azure-policy/commits/master/built-in-policies.atom) of all the commits in the built-in-policies folder which can be used for a RSS feed.

## Versioning

Each policy definition and initiative contains a version in its metadata section:
```json
"metadata": {
   "version": "1.0.0",
   "category": "{categoryName}"
}
```

This version is incremented according to the following rules (subject to change):
   - **Major Version** (**1**.0.0)
      
      Starting in November 2022, there will be no further changes to the major versions of built in policies. Changes that required a major version to be incremented in the past will now increment the minor version instead. The Azure Policy team is working to add "full" versions support for policy resources, where each policy could have multiple versions that can be referenced individually. Temporarily blocking updates to major versions is required to complete this work.
   - **Minor Version** (1.**0**.0)
      - Policy Definitions
         - Rule logic changes
         - ifNotExists existence condition changes
         - Major changes to the effect of the policy (i.e. adding a new resource to a deployment)
         - Changes to effect details that don't meet the major version criteria
         - Adding new parameter allowed values
         - Adding new parameters (with default values)
         - Other minor changes to existing parameters
      - Policy Set Definitions
         - Addition or removal of a policy definition from the policy set
         - Adding new parameter allowed values
         - Adding new parameters (with default values)
         - Other minor changes to existing parameters
   - **Patch Version** (1.0.**0**)
      - Policy Definitions
         - String changes (displayName, description, etc…)
         - Other metadata changes
      - Policy Set Definitions
         - String changes (displayName, description, etc…)
         - Other metadata changes
   - **Suffix**
      - Append "-preview" to the version if the policy is in a preview state  
         - Example:  1.3.2-preview
      - Append "-deprecated" to the version if the policy is in a deprecated state
         - Example:  1.3.2-deprecated
 
## Preview and deprecated policies

This section aims to explain what it means when a built-in policy has a state of ‘preview’ or ‘deprecated’.  

Policies can be in preview because a property (alias) referenced in the policy definition is in preview, or the policy is newly introduced and would like additional customer feedback. A policy may get deprecated when the property (alias) becomes deprecated & not supported in the resource type's latest API version, or when there is manual migration needed by customers due to a breaking change in a resource type's latest API version. 

When a policy gets deprecated or gets out of preview, there is no impact on existing assignments. Existing assignments continue to work as-is. The policy is still evaluated & enforced like normal and continues to produce compliance results.  

Here are the changes that occur when a policy gets deprecated: 
- Display name is appended with ‘[Deprecated]:’ prefix, so that customers have awareness to migrate or delete the policy.  
- Description gets updated to provide additional information regarding the deprecation. 
- The version number is updated with ‘-deprecated’ suffix. (see [Versioning](#versioning) above) 

To deter customers from making any new assignments, deprecated definitions are hidden in the definition list view in Azure Portal. 

Here are the changes that occur when a policy gets out of preview: 
- Display name is no longer appended with ‘[Preview]:’ prefix. 
- The version number is updated to remove the ‘-preview’ suffix. (see [Versioning](#versioning) above) 

For customers who do not want such changes to impact their policy definitions, we recommend duplicating built-in policy definitions & assigning them as custom definitions. Customers can also choose to be notified of updates by [subscribing](https://docs.github.com/account-and-profile/managing-subscriptions-and-notifications-on-github/setting-up-notifications/configuring-notifications#configuring-your-watch-settings-for-an-individual-repository) to this Github repository.  
 
## Contributing
Changes can not be made to built-in policies directly in this repo. If you find an issue in a built-in policy, feel free to [open an issue](https://github.com/Azure/azure-policy/issues/new/choose), or [open a Microsoft Azure support ticket](https://azure.microsoft.com/support/create-ticket/). Changes to built-ins are made out-of-band and will be represented in this repo after the next built-in policy release.
