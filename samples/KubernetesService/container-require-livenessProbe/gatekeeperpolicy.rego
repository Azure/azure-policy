   package admission

    import data.k8s.matches
    
    ###############################################################################
    #
    # Policy : Ensure all containers have a httpGet livenessProbe defined
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
        not container.livenessProbe
        not livenessProbe_complete(container.livenessProbe)
        msg := sprintf("The operation was disallowed by policy ‘{{AzurePolicyID}}’. Error details: container %v must define a httpGet livenessProbe", [container.name])
    }

    livenessProbe_complete(livenessProbe) = true {
        not livenessProbe == {}
        not livenessProbe.httpGet == {}
        livenessProbe.httpGet["path"]
        livenessProbe.httpGet["port"]
    }