    package admission

    import data.k8s.matches
    
    ##############################################################################
    #
    # Policy : Enforce internal load balancers
    #
    ##############################################################################

    deny[{
        "id": "{{AzurePolicyID}}",            # identifies type of violation
        "resource": {
            "kind": "services",               # identifies kind of resource
            "namespace": namespace,           # identifies namespace of resource
            "name": name                      # identifies name of resource
        },
        "resolution": {"message": msg},       # provides human-readable message to display
    }] {
        matches[["services", namespace, name, matched_service]]
        namespace != "kube-system"
        not loadbalancer_no_pip(matched_service)
        msg := sprintf("The operation was disallowed by policy ‘{{AzurePolicyID}}’. Error details: loadbalancers should not have public ips. azure-load-balancer-internal annotation is required for %v", [matched_service.metadata.name])
    }
    
    loadbalancer_no_pip(service) = true {
        service.spec.type == "LoadBalancer"
        service.metadata.annotations["service.beta.kubernetes.io/azure-load-balancer-internal"] == "true"
    }

    loadbalancer_no_pip(service) = true {
    	service.spec.type != "LoadBalancer"
    }