    package admission

    import data.k8s.matches
    
    ###############################################################################
    #
    # Policy : Ensure container CPU and memory resource limits defined
    #
    ###############################################################################
    deny[{
        "id": "{{AzurePolicyID}}",          # identifies type of violation
        "resource": {
            "kind": "pods",                 # identifies kind of resource
            "namespace": namespace,         # identifies namespace of resource
            "name": name                    # identifies name of resource
        },
        "resolution": {"message": msg},     # provides human-readable message to display
    }] {
        matches[["pods", namespace, name, matched_pod]]
        namespace != "kube-system"
        container = matched_pod.spec.containers[_]
        not resources_complete(container.resources)
        msg := sprintf("The operation was disallowed by policy ‘{{AzurePolicyID}}’. Error details: CPU and memory resource limits are not defined for container %q", [container.name])
    }
    resources_complete(resources) = true {
        not resources == {}
        not resources.limits == {}
        resources.limits["memory"]
        resources.limits["cpu"]
    }