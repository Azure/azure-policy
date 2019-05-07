    package admission

    import data.k8s.matches
    
    ###############################################################################
    #
    # Policy : Ensure containers listen only on allowed ports 
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
        port = container.ports[_]
        format_int(port.containerPort, 10, portstr)
        not re_match("{{policyParameters.allowedContainerPortsRegex}}", portstr)
        msg := sprintf("The operation was disallowed by policy ‘{{AzurePolicyID}}’. Error details: container port %v for container %v has not been whitelisted.", [portstr, container.name])
    }
