    package admission

    import data.k8s.matches
    
    ##############################################################################
    #
    # Policy : Enforce unique ingress hostnames across all namespaces.
    #
    ##############################################################################

    deny[{
        "id": "{{AzurePolicyID}}",        # identifies type of violation
        "resource": {
            "kind": "ingresses",          # identifies kind of resource
            "namespace": namespace,       # identifies namespace of resource
            "name": name                  # identifies name of resource
        },
        "resolution": {
            "message": "The operation was disallowed by policy ‘{{AzurePolicyID}}’. Error details: ingress host conflicts with an existing ingress."    # provides human-readable message to display
            },
    }] {
        matches[["ingresses", namespace, name, matched_ingress]]
        matches[["ingresses", other_ns, other_name, other_ingress]]
        name != other_name
        other_ingress.spec.rules[_].host == matched_ingress.spec.rules[_].host
    }
