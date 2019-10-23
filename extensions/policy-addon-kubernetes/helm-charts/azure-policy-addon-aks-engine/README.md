# Azure Policy Add-on for AKS Engine

Azure Policy integrates with [AKS Engine](https://github.com/Azure/aks-engine/blob/master/docs/README.md), a system which provides convenient tooling to quickly bootstrap a self-managed Kubernetes cluster on Azure. This integration enables at-scale enforcements and safeguards on your AKS Engine self-managed clusters in a centralized, consistent manner. By extending use of [Open Policy Agent](https://www.openpolicyagent.org/) (OPA) [Gatekeeper](https://github.com/open-policy-agent/gatekeeper) v3, an _admission controller webhook_ for Kubernetes, Azure Policy makes it possible to manage and report on the compliance state of your Azure resources and AKS Engine self-managed clusters from one place.

> [!NOTE]
> Azure Policy for AKS Engine is in Public Preview. The service only supports built-in policy
> definitions and a single AKS Engine cluster in a resource group configured with a Service
> Principal.

To enable and use Azure policy add-on for AKS Engine, please refer [Install Azure Policy Add-on on AKS Engine](https://aka.ms/kubepolicydoc).