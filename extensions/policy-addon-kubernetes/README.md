# Azure Policy Add-on for Kubernetes
The _Azure Policy Add-on_ for Kubernetes connects the Azure Policy service to the [Gatekeeper](https://github.com/open-policy-agent/gatekeeper) v3, an _admission controller webhook_ for Kubernetes. The add-on enacts the following functions:

- Checks with Azure Policy for assignments to the cluster
- Downloads and installs policy details, constraint templates, and constraints 
- Runs a full scan compliance check on the cluster
- Reports auditing and compliance details back to Azure Policy

Azure Policy currently integrates with [AKS Engine](https://github.com/Azure/aks-engine/blob/master/docs/README.md), a system which provides convenient tooling to quickly bootstrap a self-managed Kubernetes cluster on Azure. The add-on can be installed and enabled on AKS Engine cluster using the helm charts in this repo. 

For detailed instructions to enable and use Azure policy add-on for AKS Engine, please refer [Install Azure Policy Add-on on AKS Engine](https://aka.ms/kubepolicydoc).