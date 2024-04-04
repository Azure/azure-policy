# Azure Policy Samples

This repository contains the direct representation of built-in definitions published to Azure. For easy search of all built-in  with descriptions, see [Policy samples](https://docs.microsoft.com/azure/governance/policy/samples/) on docs.microsoft.com.

For custom policy samples, check out our Community repo! (https://github.com/Azure/Community-Policy)

## Contributing

To contribute, please submit your policies to our Community repo! (https://github.com/Azure/Community-Policy)

## Reporting Issues

The support for addressing built-in definition issues is handled by Azure Customer Support. Open a new [**Azure Customer Support ticket**](https://azure.microsoft.com/support/create-ticket/) if you believe a definition has a bug or error.

# Azure Policy Known Issues

Check here for a current list of [**known issues**](#known-issues) for Azure Policy.

# Azure Policy Resources

## Articles

- [Azure Policy overview](https://docs.microsoft.com/azure/governance/policy/overview)
- [How to assign policies using the Azure portal](https://docs.microsoft.com/azure/governance/policy/assign-policy-portal)
- [How to assign policies using Azure PowerShell](https://docs.microsoft.com/azure/governance/policy/assign-policy-powershell)
- [How to assign policies using Azure CLI](https://docs.microsoft.com/azure/governance/policy/assign-policy-azurecli)
- [Export and manage Azure Policy resources as code with GitHub](https://docs.microsoft.com/azure/governance/policy/tutorials/policy-as-code-github)
- [Definition structure](https://docs.microsoft.com/azure/governance/policy/concepts/definition-structure)
- [Understand Policy effects](https://docs.microsoft.com/azure/governance/policy/concepts/effects)
- [Get compliance data](https://docs.microsoft.com/azure/governance/policy/how-to/get-compliance-data)
- [Remediate non-compliant resources](https://docs.microsoft.com/azure/governance/policy/how-to/remediate-resources)

## References

- [Azure CLI](https://docs.microsoft.com/cli/azure/policy)
- Azure PowerShell
  - [Policy](https://docs.microsoft.com/powershell/module/az.resources/#policies)
  - [Guest Configuration (preview)](https://www.powershellgallery.com/packages/AzureRM.GuestConfiguration)
- REST API
  - [Policy Definitions](https://docs.microsoft.com/en-us/rest/api/policy/policy-definitions)
  - [Initiative Definitions](https://docs.microsoft.com/en-us/rest/api/policy/policy-set-definitions)
  - [Assignments](https://docs.microsoft.com/en-us/rest/api/policy/policy-assignments)
  - [Exemptions](https://docs.microsoft.com/en-us/rest/api/policy/policy-exemptions)
  - [States](https://docs.microsoft.com/en-us/rest/api/policy/policy-states)
  - [Events](https://docs.microsoft.com/en-us/rest/api/policy/policy-events)
  - [Remediations](https://docs.microsoft.com/en-us/rest/api/policy/remediations)
  - [Metadata](https://docs.microsoft.com/en-us/rest/api/policy/policy-metadata)
  - [Policy Tracked Resources](https://docs.microsoft.com/en-us/rest/api/policy/policy-tracked-resources)
  - [Guest Configuration (preview)](https://docs.microsoft.com/rest/api/guestconfiguration/)

## Getting Support

The general Azure Policy support role of this repository has transitioned to standard Azure support channels. See below for information about getting support help for Azure Policy.

### Alias Requests

An alias enables you to restrict what values or conditions are permitted for a *property* on a resource. Each alias maps to the paths in different API versions for a given resource type. During policy evaluation, the policy engine gets the property path for that API version.
See the documentation page on aliases [**here**](https://docs.microsoft.com/azure/governance/policy/concepts/definition-structure#aliases). For additional information about Azure Policy and aliases, visit this [**blog post**](https://azure.microsoft.com/blog/more-resource-policy-aliases/).

Support for requesting aliases is handled by Azure Customer Support. Open a new [**Azure Customer Support ticket**](https://azure.microsoft.com/support/create-ticket/) if you believe you need new aliases to be published.

[**This page**](https://docs.microsoft.com/azure/governance/policy/concepts/definition-structure#aliases) documents the commands for discovering existing aliases.

### General Questions

If you have questions you haven't been able to answer from the [**Azure Policy documentation**](https://docs.microsoft.com/azure/governance/policy), there are a few places that host discussions on Azure Policy:

 - [Microsoft Tech Community](https://techcommunity.microsoft.com/) [**Azure Governance conversation space**](https://techcommunity.microsoft.com/t5/Azure-Governance/bd-p/AzureGovernance)
 - Join the Customer Call on Azure Governance (register [here](https://forms.office.com/Pages/ResponsePage.aspx?id=v4j5cvGGr0GRqy180BHbRxn7UD7lweFDnmuLj72r6E1UN1dLNTBZUVMyNVpHUjJLRE5PVDVGNlkyOC4u)) 
 - Search old [**issues in this repo**](https://github.com/Azure/azure-policy/issues)
 - Search or add to Azure Policy discussions on [**StackOverflow**](https://stackoverflow.com/questions/tagged/azure-policy+or+azure+policy)
 - Feature request please add or vote on [**Ideas**](https://feedback.azure.com/d365community/forum/675ae472-f324-ec11-b6e6-000d3a4f0da0#) with Category: "Azure Policy"

If your questions are more in-depth or involve information that is not public, open a new [**Azure Customer Support ticket**](https://azure.microsoft.com/support/create-ticket/).

### Documentation Corrections

To report issues in the Azure Policy online documentation, look for a feedback area at the bottom of the page. If you don't see a place to enter feedback, you can also directly open a new issue at the [**Microsoft Docs GitHub**](https://github.com/MicrosoftDocs/feedback/issues).

### Other Support for Azure Policy

If you are encountering livesite issues or difficulties in implementing new policies that may be due to problems in Azure Policy itself, open a support ticket at [**Azure Customer Support**](https://azure.microsoft.com/support/create-ticket/). If you want to submit an idea for consideration, add an idea or upvote an existing idea at [**Azure Governance Ideas**](https://feedback.azure.com/d365community/forum/675ae472-f324-ec11-b6e6-000d3a4f0da0#).

## Known Issues

Azure Policy operates at a level above other Azure services by applying policy rules against PUT requests and GET responses of resource types going between Azure Resource Manager and the owning resource provider (RP). In a few cases, the behavior of a given RP is unexpected or incompatible in some way with Azure Policy. The Azure Policy team works with the RP teams to close these gaps as soon as possible after they are discovered. Usually aliases for properties of these resource types will be removed after the anomalous behavior is discovered. Issues of this nature will be documented here until final resolution.

All cases of known resource types with anomalous policy behavior are listed here. Currently there is no way to make these resource types invisible at policy authoring time, so writing policies that attempt to manage these resource types cannot be prevented, despite the fact that the results of such policies may be either incomplete or incorrect.

### Resource Type query results incomplete, missing, or non-standard format

In some cases, certain RPs may return incomplete or otherwise limited or missing information about resources of a given type. The Azure Policy engine is unable to determine the compliance of any resources of such a type. Below are listed the known resource types exhibiting this problem.

- Microsoft<span></span>.Web/sites/config/* (except Microsoft<span></span>.Web/sites/config/web)
- Microsoft<span></span>.Web/sites/slots/config/* (except Microsoft<span></span>.Web/sites/slots/config/web)

Currently, there is no plan to change this behavior for the above Microsoft.Web resource types. If this scenario is important to you, please [open a support ticket](https://azure.microsoft.com/support/create-ticket/) with the Web team.

- Microsoft.HDInsights/clusters/computeProfile.roles[*].scriptActions
- Microsoft.Sql/servers/auditingSettings
  - This type will work correctly as the related resource in `AuditIfNotExists` and `DeployIfNotExists` policies, as long as a `name` for the resource is provided, e.g:
  ```       "effect": "AuditIfNotExists",
            "details": {
              "type": "Microsoft.Sql/servers/auditingSettings",
              "name": "default"
            }
   ```
- Microsoft.DataLakeStore/accounts
  - This type behaves similarly to Microsoft.Sql/servers/auditingSettings. Compliance of some fields cannot be determined except in `AuditIfNotExists` and `DeployIfNotExists` policies.
- Microsoft.DataLakeStore/accounts/encryptionState 
  - This property of this type is populated differently when queried than when created or updated unless non-standard parameters are provided. This means deny policies will work, but compliance audits will generally not be correct.
- Microsoft.Sql 'master' database 
   - This type behaves similarly to Microsoft.Sql/servers/auditingSettings. Compliance of some fields cannot be determined except in `AuditIfNotExists` and `DeployIfNotExists` policies.
- Microsoft.Compute/virtualMachines/instanceView
  - Collection query of this type is missing many properties, which means compliance checks may not work.
- Microsoft.Network/virtualNetworks/subnets
  - The routeTable property of this type is populated differently when queried than when created or updated unless non-standard parameters are provided. This means deny policies will work, but compliance audits will generally not be correct.
- Microsoft.Insights/workbooks
  - The collection GET API call for this type doesn't return all workbooks, which could result in some or all workbook resources being incorrectly flagged as non-compliant.
- Microsoft.Maintenance/configurationAssignments
  - This type does not support LIST API which does not allow for compliance results to be populated.
- Microsoft.Maintenance/applyUpdates
  - This type does not support LIST API which does not allow for compliance results to be populated.
- Microsoft.Cdn/CdnWebApplicationFirewallPolicies
  - This type does not support LIST API which does not allow for compliance results to be populated. This type also does not support GET API calls at a subscription level which can lead to incorrect compliance results over time.
- Microsoft.EventGrid/eventSubscriptions
  - This type does not support LIST API which does not allow for compliance results to be populated.

### Resource Type not correctly published by resource provider

In some cases, a resource provider may implement a resource type, but not correctly publish it to the Azure Resource Manager. The result of this is that Azure Policy is unable to discover the type in order to determine compliance. In some cases, this still allows deny policies to work, but compliance results will usually be incorrect. These are the resource types known to have this behavior:

- Microsoft.DBforPostgreSQL/serverGroupsv2
- Microsoft.AppConfiguration/ConfigurationStores

In some cases the unpublished resource type is actually a subtype of a published type, which causes aliases to refer to a parent type instead of the unpublished type. Evaluation of such policies fails, causing the policy to never apply to any resource.

These resource types previously exhibited this behavior but have been fixed:

- Microsoft.EventHub/namespaces/networkrulesets
- Microsoft.ServiceBus/namespaces/networkrulesets
- Microsoft.Sql/servers/databases/backupShortTermRetentionPolicies
- Microsoft.ApiManagement/service/portalsettings/delegation
- Microsoft.Storage/storageAccounts/blobServices

### Resource management that bypasses Azure Resource Manager

Resource providers are free to implement their own resource management operations outside of Azure Resource Manager ("dataplane" operations). In almost every Azure resource type, the distinction between resource management and dataplane operations is clear and the resource provider only implements resource management one way. Occasionally, a resource provider may choose to implement a type that can be managed both ways. In this case, Azure Policy controls the standard Azure Resource Manager API normally, but operations on the direct resource provider API to create, modify and delete resources of that type bypass Azure Resource Manager so they are invisible to Azure Policy. Since policy enforcement is incomplete, we recommend that customers do not implement policies targeting such a resource type.
This is the list of known such resource types:

- Microsoft.Storage/storageAccounts/blobServices/containers

The storage team has implemented blob public access control on storage accounts to address this scenario. Per-account public access control of blobs can be controlled by Azure Policy using the new alias ```Microsoft.Storage/storageAccounts/allowBlobPublicAccess```.


 - Microsoft.Sql/servers/firewallRules

Firewall rules can be created/deleted/modified via T-SQL commands, which bypasses Azure Policy. There is currently no plan to address this.

- Microsoft.ServiceFabric/clusters/applications

Service Fabric applications created via direct requests to the Service Fabric cluster (i.e. via New-ServiceFabricApplication) will not appear in the Azure Resource Manager representation of the Service Fabric cluster. Policy will not be able to audit/enforce these applications.

Note that Azure policies for dataplane operations of certain targeted resource providers is also supported or under active development. Please see the [Resource Provider modes.](https://learn.microsoft.com/azure/governance/policy/concepts/definition-structure#resource-provider-modes)

### Nonstandard creation pattern

In a few instances, the creation pattern of a resource type doesn't follow normal REST patterns. In these cases, deny policies may not work or may only work for some properties. For example, certain resource types may PUT only a subset of the properties of the resource type to create the entire resource. With such types the resource provider selects the values for properties not provided in the payload. Such a resource might be created with a non-compliant value even though a deny policy exists to prevent it. A similar result may occur if a set of resource types can be created using a collection PUT. Known resource types that exhibit this class of behavior:

- Microsoft.Automation/certificates
- Microsoft.Security/securityContacts

There is currently no plan to change this behavior for these types. If this scenario is important to you, please [open a support ticket](https://azure.microsoft.com/support/create-ticket/) with the Azure SQL or Automation team.

### Nonstandard update pattern through Azure Portal
In some cases, a resource provider can choose not to follow normal REST patterns when a resource is updated via the portal. In these cases, a partial PUT request is done instead of a PATCH request causing the policy engine to evaluate as if some properties do not have values. 

- Microsoft.Web/sites 

### Provider pass-through to non Azure Resource Manager resources

There are examples where a resource provider publishes a resource type to Azure Resource Manager, but the resources it represents cannot be managed by Azure Resource Manager. For example, Microsoft.Web has published several resource types to Azure Resource Manager that actually represent resources of the customer's site rather than Azure Resource Manager resources. Such resources cannot or should not be managed by Azure policy, and are explicitly excluded. All known examples are listed here:

- Microsoft.Web/sites/deployments
- Microsoft.Web/sites/functions
- Microsoft.Web/sites/instances/deployments
- Microsoft.Web/sites/siteextensions
- Microsoft.Web/sites/slots/deployments
- Microsoft.Web/sites/slots/functions
- Microsoft.Web/sites/slots/instances/deployments
- Microsoft.Web/sites/slots/siteextensions
- Microsoft.Web/sites/sourcecontrols
- Microsoft.Web/sites/slots/sourcecontrols
- Microsoft.Web/sites/privateaccess

### Legacy or incorrect aliases

Since custom policies use aliases directly, it is usually not possible to update them without causing unintended side effects to existing custom policies. This means that aliases referring to incorrect information or following legacy naming conventions must be left in place, even though it may cause confusion. In certain cases where an alias is known to refer to the wrong information, another alias may be created as a corrected alternative to the known bad one. In these cases, the new alias will be given the name of the bad alias with .v2 appended. For example a bad alias named Microsoft.ResourceProvider/someType/someAlias would result in the addition of a corrected version named Microsoft.ResourceProvider/someType/someAlias.v2. If an alias is added to correct a .v2 alias it will be named by replacing v2 with v3. All known corrected aliases are listed here:

- Microsoft.Sql/servers/databases/requestedServiceObjectiveName.v2

To enforce around SQL databases transparentDataEncryption, please use both the legacy alias (api versions between 2014-04-01 and 2022-05-01-preview) Microsoft.Sql/transparentDataEncryption.status and the new alias (post api version 2022-05-01-preview) Microsoft.Sql/servers/databases/transparentDataEncryption/state.  

Resource property names that include symbols or numbers such as dashings '-' or slashes '/' are a nonstandard creation pattern and alias for those properities are not generated. 

### Optional or auto-generated resource property that bypasses policy evaluation

In a few instances, when creating a resource from Azure Portal, the property is not set in the PUT request payload. When the request reaches the resource provider, the resource provider generates the property and sets the value. Because the property is not in the request payload, the policy cannot evaluate the property. Known resource fields that exhibit this class of behavior:

- Microsoft.Storage/storageAccounts/networkAcls.defaultAction
- Microsoft.Authorization/roleAssignments/principalType
- Microsoft.Compute/virtualMachines/storageProfile.osDisk.osType
- Microsoft.Compute/virtualMachines/storageProfile.osDisk.diskSizeGB
- Microsoft.Compute/virtualMachineScaleSets/virtualMachineProfile.storageProfile.osDisk.diskSizeGB
- Microsoft.Compute/virtualMachineScaleSets/virtualMachines/storageProfile.osDisk.diskSizeGB
- Microsoft.Authorization/roleAssignmentScheduleInstances/* (all aliases)
- Microsoft.Cache/Redis/privateEndpointConnections[\*]
- Microsoft.Cache/Redis/privateEndpointConnections[\*].provisioningState
- Microsoft.Cache/Redis/privateEndpointConnections[\*].privateLinkServiceConnectionState.status

Using this type of alias in the existence condition of auditIfNotExists or deployIfNotExists policies works correctly. These two kinds of effects will get the full resource content to evaluate the existence condition. The property is always present in GET request payloads.

Using this type of alias in audit/deny/append effect policies works partially. The compliance scan result will be correct for existing resources. However, when creating/updating the resource, there will be no audit events for audit effect policies and no deny or append behaviors for deny/append effect policies because of the missing property in the request payload.

- Microsoft.Databricks/* (Creation time only)

All Databricks resources bypass policy enforcement at creation time. Databricks resources will have policy enforcement post-creation. To provide feedback on this, please leverage the [Databricks UserVoice](https://feedback.azure.com/forums/909463-azure-databricks). 

### Resources that are exempt from policy evaluation

Resource types in the following namespaces are excluded from policy evaluation:
- Microsoft.Resources/*, except resource groups and subscriptions. 
   - For example, `Microsoft.Resources/deployments` and `Microsoft.Resources/templateSpecs` are not evaluated by policy.
- Microsoft.Billing/*
- Microsoft.Capacity/reservationOrders/*
- Microsoft.Help/*
- Microsoft.Diagnostics/*

The following resource types are also excluded from policy evaluation:
- Microsoft.Automation/automationAccounts/jobs
- Microsoft.Cdn/cdnWebApplicationFirewallManagedRuleSets
- Microsoft.Cdn/edgenodes
- Microsoft.classicNetwork/ExpressRouteCrossConnections
- Microsoft.Compute/restorePointCollections/restorePoints
- Microsoft.Databricks/workspaces/dbWorkspaces
- Microsoft.DocumentDb/databaseAccounts/privateEndpointConnectionProxies
- Microsoft.KeyVault/vaults/secrets
- Microsoft.KubernetesConfiguration/extensions
- Microsoft.Maintenance/configurationAssignments
- Microsoft.Maintenance/applyUpdates
- Microsoft.Security/assessments
- Microsoft.SecurityInsights/incidents
- Microsoft.ServiceBus/namespaces/topics
- Microsoft.Sql/Servers/databases/recommendedSensitivityLabels

### Resource types that exceed current enforcement and compliance scale

There some resource types that are generated at very high scale. These are not suitable for management by Azure Policy because the enforcement and compliance checks create overhead that can negatively impact the performance of the API itself. Most of these are not significant policy scenarios, but there are a few exceptions.

These are resource types that have significant policy scenarios, but are not supported by Azure Policy due to the above scalability considerations:

- Microsoft.ServiceBus/namespaces/topics
- Microsoft.ServiceBus/namespaces/topics/authorizationRules
- Microsoft.ServiceBus/namespaces/topics/subscriptions
- Microsoft.ServiceBus/namespaces/topics/subscriptions/rules

Work to increase the scale that policy can be performantly applied to resource types is in progress. Planned availability date is not yet determined.

### Alias changes  

May 2020: Microsoft.DocumentDB/databaseAccounts/ipRangeFilter updated from a string property to an array.  Please re-author your custom definitions to support the property as an array.  
July 2020: The alias Microsoft.Sql/servers/securityAlertPolicies/emailAddresses[] and related policies were deprecated. 

### Resource types that do not display non-compliance messages in the portal during preflight validation   

There are resource types that do not properly display non-compliance messages in the portal during preflight validation, but instead they show a link to the activity log.

This behavior is seen in the following resource types:
- Microsoft.Kusto/clusters
- Microsoft.Cdn/profiles
- Microsoft.ContainerRegistry/registries
- Microsoft.Cache/Redis

This behavior is also seen in resource types from the following RPs:
- Microsoft.DataLakeAnalytics
- Microsoft.DataLakeStore
- Microsoft.DBforMySQL
- Microsoft.HDInsight

### Azure Policy Extension for Arc is not compatible on Kubernetes 1.25 (preview) version

Policy extension for Arc installation will fail on 1.25 clusters with the following error code and message: 
Code: ExtensionOperationFailed
"err [unable to build kubernetes objects from release manifest:
unable to recognize "": no matches for kind "PodSecurityPolicy" in version "policy/v1beta1"]} occurred while doing the operation :"

Mitigation: Avoid using K8s 1.25 (preview) with the Azure Policy Extension for Arc. The extension can be used with any GA supported version such as 1.22, 1.23, or 1.24. 
Feature team is actively working on fixing this issue. We will update this known issue once the resolution is available.

For support involving these compliance message issues, please first follow up with the respective RP listed above.

### Resource types that do not support creation of Policy exemptions
These resource types do not allow Policy exemptions on resources due to [deny assignments](https://docs.microsoft.com/azure/role-based-access-control/deny-assignments). Workaround is to use [exclusions](https://docs.microsoft.com/azure/governance/policy/concepts/assignment-structure#excluded-scopes) at the assignment level. 

- Microsoft.Databricks/*

### Resource types with unsupported property names
Currently Azure Policy supports only alphanumeric characters for property and alias names. There are a handful of resource types with property names containing non-alphanumeric characters. These properties cannot currently be onboarded to Azure Policy:

Microsoft.Cache/Redis/
  - redisConfiguration.rdb-backup-enabled
  - redisConfiguration.rdb-backup-frequency
  - redisConfiguration.rdb-backup-max-snapshot-count
  - redisConfiguration.rdb-storage-connection-string
  - redisConfiguration.aof-storage-connection-string-0
  - redisConfiguration.aof-storage-connection-string-1
  - redisConfiguration.maxfragmentationmemory-reserved
  - redisConfiguration.maxmemory-policy
  - redisConfiguration.maxmemory-reserved
  - redisConfiguration.maxmemory-delta
  - redisConfiguration.aof-backup-enabled
  - redisConfiguration.zonal-configuration
  - redisConfiguration.preferred-data-archive-auth-method
  - redisConfiguration.preferred-data-persistence-auth-method

*This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/). For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.*
