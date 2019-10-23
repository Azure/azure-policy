# Built-in references
Built-in references folder contains the artifacts like YAML, REGO files referred in Azure policy built-in definitions.

## KubernetesService
KubernetesService folder contains the [REGO](https://www.openpolicyagent.org/docs/how-do-i-write-policies.html#what-is-rego) artifacts used by [Gatekeeper v2](https://github.com/open-policy-agent/gatekeeper/tree/master/deprecated), admission controller for [Azure Kubernetes Service (AKS)](https://docs.microsoft.com/azure/aks/intro-kubernetes).

> [!NOTE]
> Azure Policy for AKS is in Limited Preview and only supports built-in policy definitions.

To onboard to Azure policy for AKS, please refer [Azure Policy for AKS](https://aka.ms/akspolicydoc).


## Kubernetes
Kubernetes folder contains the [OPA Constraint Framework](https://github.com/open-policy-agent/frameworks/tree/master/constraint) constraint template and constraint YAML artifacts used by [Gatekeeper v3](https://github.com/open-policy-agent/gatekeeper), admission controller for [AKS Engine](https://github.com/Azure/aks-engine), a self-managed Kubernetes cluster on Azure.

> [!NOTE]
> Azure Policy for AKS Engine is in Public Preview. The service only supports built-in policy 
> definitions and a single AKS Engine cluster in a resource group configured with a Service 
> Principal.

To onboard to Azure policy for AKS Engine, please refer [Azure Policy for AKS Engine](https://aka.ms/kubepolicydoc).