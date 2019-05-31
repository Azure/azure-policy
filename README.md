# Azure Policy

Check here for a current list of [**known issues**](#known-issues).

## Alias Requests

[**Requesting Policy Aliases**](#requesting-policy-aliases)

## Samples

This repository contains samples of Azure Policies that can be used as reference for creating and assigning policies to your subscriptions and resource groups. For a full list of samples with descriptions, see [Policy samples](https://docs.microsoft.com/azure/governance/policy/samples/) on docs.microsoft.com.

### Articles

- [Azure Policy overview](https://docs.microsoft.com/azure/governance/policy/overview)
- [How to assign policies using the Azure portal](https://docs.microsoft.com/azure/governance/policy/assign-policy-portal)
- [How to assign policies using Azure PowerShell](https://docs.microsoft.com/azure/governance/policy/assign-policy-powershell)
- [How to assign policies using Azure CLI](https://docs.microsoft.com/azure/governance/policy/assign-policy-azurecli)
- [Definition structure](https://docs.microsoft.com/azure/governance/policy/concepts/definition-structure)
- [Understand Policy effects](https://docs.microsoft.com/azure/governance/policy/concepts/effects)
- [Audit VMs with Guest Configuration](https://docs.microsoft.com/azure/governance/policy/concepts/guest-configuration)
- [Programmatically create policies](https://docs.microsoft.com/azure/governance/policy/how-to/programmatically-create)
- [Get compliance data](https://docs.microsoft.com/azure/governance/policy/how-to/get-compliance-data)
- [Remediate non-compliant resources](https://docs.microsoft.com/azure/governance/policy/how-to/remediate-resources)

### References

- [Azure CLI](https://docs.microsoft.com/cli/azure/policy)
- Azure PowerShell
  - [Policy](https://docs.microsoft.com/powershell/module/az.resources/#policies)
  - [Guest Configuration (preview)](https://www.powershellgallery.com/packages/AzureRM.GuestConfiguration)
- REST API
  - [Events](https://docs.microsoft.com/rest/api/policy-insights/policyevents)
  - [States](https://docs.microsoft.com/rest/api/policy-insights/policystates)
  - [Assignments](https://docs.microsoft.com/rest/api/resources/policyassignments)
  - [Policy Definitions](https://docs.microsoft.com/rest/api/resources/policydefinitions)
  - [Initiative Definitions](https://docs.microsoft.com/rest/api/resources/policysetdefinitions)
  - [Policy Tracked Resources](https://docs.microsoft.com/rest/api/policy-insights/policytrackedresources)
  - [Remediations](https://docs.microsoft.com/rest/api/policy-insights/remediations)
  - [Guest Configuration (preview)](https://docs.microsoft.com/rest/api/guestconfiguration/)

### Other

- [Video - Build 2018](https://channel9.msdn.com/events/Build/2018/THR2030)

## Contributing

To contribute and get started, please visit our [**contribution guide**](./1-contribution-guide/README.md#contribution-guide).

## Requesting Policy Aliases

To request a new alias, please open a new issue following the instructions [**here**](./1-contribution-guide/request-alias.md)

*This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/). For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.*

## Known Issues

Azure Policy operates at a level above other Azure services by applying policy rules against PUT requests and GET responses of resource types going between Azure Resource Manager and the owning resource provider (RP). In a few cases, the behavior of a given RP is unexpected or incompatible in some way with Azure Policy. The Azure Policy team works with the RP teams to close these gaps as soon as possible after they are discovered. Issues of this nature will be listed here until closed. To get something added to this list that isn't already reported in [**Issues**](./issues), open a [**new issue**](./issues/new/choose).

All cases of known resource types with anomalous policy behavior are listed here. Currently there is no way to make these resource types invisible at policy authoring time, so writing policies that attempt to manage these resource types cannot be prevented, despite the fact that the results of such policies will be either incomplete or incorrect.

### Resource Type query results incomplete/missing

  In some cases, certain RPs may return incomplete or otherwise limited or missing information about resources of a given type. The Azure Policy engine is unable to determine the compliance of any resources of such a type. Here are the known resource types with this problem.

  - Microsoft<span></span>.Web/sites/siteConfig
  - Microsoft<span></span>.Web/sites/config/* (except Microsoft<span></span>.Web/sites/config/web)

Currently, there is no plan to change this behavior. If this scenario is important to you, please open a support ticket with the Web team.

### Resource Type not correctly published by resource provider

  In some cases, a resource provider may implement a resource type, but not correctly publish it to the Azure Resource Manager. The result of this is that Azure Policy is unable to discover the type in order to determine compliance. In some cases, this still allows deny policies to work, but compliance results will usually be incorrect. These resource types exhibit this behavior:

  - Microsoft.EventHub/namespaces/networkRuleSet
  - Microsoft.ServiceBus/namespaces/networkRuleSet
  - Microsoft.Storage/storageAccounts/blobServices

  In many of these cases the unpublished resource type is actually a subtype of a published type, which causes aliases to refer to the parent type instead of the unpublished type. Evaluation of such policies fails, causing the policy to never apply to any resource. Here are the known resource types with this problem:

  - Microsoft.EventHub/namespaces/networkRuleSets
  - Microsoft.ServiceBus/namespaces/networkRuleSets
  - Microsoft.ApiManagement/service/portalsettings/delegation
  - Microsoft.Sql/servers/databases/backupShortTermRetentionPolicies

All of these are in the process of being addressed with the various resource provider teams. We will update this notice as things change.

### Containers

  The resource type **Microsoft.Storage/storageAccounts/blobServices/containers** is implemented on two different API sets by the storage resource provider. The first is the standard Azure Resource Manager API that is managed by Azure Policy. However, the other allows creating, updating and deleting containers with Azure dataplane operations. These operations do not go through Azure Resource Manager, so they are invisible to Azure Policy. Due to the fact that current policy management is incomplete, we have removed the associated policy aliases and recommend that customers do not implement policies that target this type.

  The storage team is working on implementing Azure Policy on its dataplane operations to address this scenario. This is expected to first be available later this year.
