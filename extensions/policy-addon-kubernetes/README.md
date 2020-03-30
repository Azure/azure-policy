# Azure Policy Add-on for Kubernetes
The Azure Policy Add-on for Kubernetes connects the Azure Policy service to the [OPA Gatekeeper](https://github.com/open-policy-agent/gatekeeper), a validating webhook that enforces Custom Resource Definitions based policies executed by Open Policy Agent, a policy engine for Cloud Native environments hosted by Cloud Native Computing Foundation as an incubation-level project.

The Azure Policy Add-on enacts the following functions:
- Checks with Azure Policy service for assignments to the cluster.
- Deploys policies in the cluster as [constraint template](https://github.com/open-policy-agent/gatekeeper#constraint-templates) and [constraint](https://github.com/open-policy-agent/gatekeeper#constraints) custom resources.
- Reports auditing and compliance details back to Azure Policy service.
    
The Azure Policy Add-on can be installed on AKS Engine and Azure Arc for Kubernetes clusters using the helm charts present in this repo.