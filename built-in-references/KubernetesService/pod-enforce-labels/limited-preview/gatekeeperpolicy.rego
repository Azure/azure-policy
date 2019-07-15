    package admission

    import data.k8s.matches
    
    ###############################################################################
    #
    # Policy : Enforce labels on pods
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
        requiredLabels := "{{policyParameters.commaSeparatedListOfLabels}}"
        delimiter := ","
        split(requiredLabels, delimiter, labels)
        label = labels[_]
        not matched_pod.metadata.labels[label]
        msg := sprintf("The operation was disallowed by policy ‘{{AzurePolicyID}}’. Error details: required label %v is missing for pod: %v", [label, matched_pod.metadata.name])
    }
