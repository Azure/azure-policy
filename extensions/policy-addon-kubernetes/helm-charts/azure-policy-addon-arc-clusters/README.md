# Azure Policy Add-on for Azure Arc for Kubernetes

Azure Policy integrates with [Azure Arc for Kubernetes](https://azure.microsoft.com/services/azure-arc/), a system to extend Azure management to Kubernetes clusters. The Azure Policy Add-on for Kubernetes connects the Azure Policy service to the [OPA Gatekeeper](https://github.com/open-policy-agent/gatekeeper), a validating webhook that enforces Custom Resource Definitions based policies executed by Open Policy Agent, a policy engine for Cloud Native environments hosted by Cloud Native Computing Foundation as an incubation-level project.

The Azure Policy Add-on enacts the following functions:
- Checks with Azure Policy service for assignments to the cluster.
- Deploys policies in the cluster as [constraint template](https://github.com/open-policy-agent/gatekeeper#constraint-templates) and [constraint](https://github.com/open-policy-agent/gatekeeper#constraints) custom resources.
- Reports auditing and compliance details back to Azure Policy service.

> [!NOTE]
> Azure Policy for Azure Arc for Kubernetes is in Preview. The service only supports built-in policy
> definitions.

To enable and use Azure Policy Add-on for Azure Arc for Kubernetes, please refer [Install Azure Policy Add-on on Azure Arc for Kubernetes](https://github.com/Azure/azure-arc-kubernetes-preview).