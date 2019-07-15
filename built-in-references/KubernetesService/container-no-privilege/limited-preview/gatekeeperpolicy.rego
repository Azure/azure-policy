   package admission

    import data.k8s.matches
    
    ###############################################################################
    #
    # Policy : Do not allow privileged containers
    # e.g. container with privileged flag set to true is not allowed
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
        not container_no_privilege(container)
        msg := sprintf("The operation was disallowed by policy ‘{{AzurePolicyID}}’. Error details: setting privileged flag to true is not allowed for container %v", [container.name])
    }

    container_no_privilege(container) = true {
        container.securityContext
        container.securityContext.privileged == false
    }
    container_no_privilege(container) = true {
        not container["securityContext"]
    }
    container_no_privilege(container) = true {
        container.securityContext
        not container.securityContext["privileged"]
    }