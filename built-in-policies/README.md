# Built-in Azure Policies

This folder contains a read-only set all of the built-in policy definitions and initiatives (a.k.a policySetDefinitions) available in Azure's public cloud. They are organized into folders by category.

Starting in January 2020 this repo will be updated each time changes are deployed to Azure. You can view the commit history for each policy to see changes over time. There is a [atom feed](https://github.com/Azure/azure-policy/commits/master/built-in-policies.atom) of all the commits in the built-in-policies folder which can be used for a RSS feed.

## Versioning

Each policy definition and initiative contains a version in it's metadata section:
```json
"metadata": {
   "version": "1.0.0",
   "category": "{categoryName}"
}
```

This version is incremented according to the following rules (subject to change):
   - **Major Version** (**1**.0.0)
      - Policy Definitions
         - Rule logic changes
         - ifNotExists existence condition changes
         - Major changes to the effect of the policy (i.e. adding a new resource to a deployment)
      - Policy Set Definitions
         - Addition or removal of a policy definition from the policy set
   - **Minor Version** (1.**0**.0)
      - Policy Definitions
         - Changes to effect details that don't meet the major version criteria
         - Adding new parameter allowed values
         - Adding new parameters (with default values)
         - Other minor changes to existing parameters
      - Policy Set Definitions
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
  
## Contributing
Changes can not be made to built-in policies directly in this repo. If you find an issue in a built-in policy feel free to open a PR with the proposed fix, [open an issue](https://github.com/Azure/azure-policy/issues/new/choose), or [open a Microsoft Azure support ticket](https://azure.microsoft.com/support/create-ticket/). The change will be made out-of-band and will be represented in this repo after the next built-in policy release.
