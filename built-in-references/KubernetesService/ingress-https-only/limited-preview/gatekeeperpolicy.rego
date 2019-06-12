    package admission

    import data.k8s.matches
    
    ##############################################################################
    #
    # Policy : Enforce HTTPS ingress.
    #
    ##############################################################################

    deny[{
        "id": "{{AzurePolicyID}}",           # identifies type of violation
        "resource": {
            "kind": "ingresses",             # identifies kind of resource
            "namespace": namespace,          # identifies namespace of resource
            "name": name                     # identifies name of resource
        },
        "resolution": {"message": msg},      # provides human-readable message to display
    }] {
        matches[["ingresses", namespace, name, matched_ingress]]
        namespace != "kube-system"
        not https_complete(matched_ingress)
        msg := sprintf("The operation was disallowed by policy ‘{{AzurePolicyID}}’. Error details: ingress should be https. tls configuration and allow-http=false annotation are required for %v", [matched_ingress.metadata.name])
    }
    
    https_complete(ingress) = true {
        ingress.spec["tls"]
        count(ingress.spec.tls) > 0
        ingress.metadata.annotations["kubernetes.io/ingress.allow-http"] == "false"
    }