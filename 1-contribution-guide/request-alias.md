# Requesting aliases for Azure Policy

## What is a policy alias?

You use aliases to access specific properties for a resource type.

An alias enable you to restrict what values or conditions are permitted for a *property* on a resource. Each alias maps to the paths in different API versions for a given resource type. During policy evaluation, the policy engine gets the property path for that API version.
For more information about Policy and aliases, visit this [**blog post**](https://azure.microsoft.com/en-us/blog/more-resource-policy-aliases/)

## Viewing existing aliases

Instructions for viewing all aliases that can be used in Azure Resource Policy are available [**here**](https://docs.microsoft.com/en-us/azure/azure-policy/policy-definition#aliases).

## How to request a new policy alias?

1. File a new [*issue*](https://github.com/Azure/azure-policy/issues) to the Azure Policy Github repository
2. Use the *Alias Request* issue template


## Example: 

**Alias request: Microsoft.Web/serverfarms/hostingEnvironmentProfile.id**

### Scenario

Ensure that all App Service plans are using an appropriate App Service Environment

### Alias
- RP: `Microsoft.Web`
- Resource Type:  `serverFarms`
- Property: `properties.hostingEnvironmentProfile.id`
    
### Example policy definition

        {
            "properties": {
                "displayName": "Only allow creation of ASP on ASE",
                "description": "Only allow creation of ASP on ASE",
                "parameters": {
                    "hostingEnvironmentProfileID": {
                        "type": "string",
                        "metadata": {
                            "description": "appServiceEnvironmentName"
                        }
                    }
                },
                "policyRule": {
                    "if": {
                        "allOf": [
                            {
                                "field": "type",
                                "equals": "Microsoft.Web/serverfarms"
                            },
                            {
                                "not": {
                                    "allOf": [
                                        {
                                            "field": "Microsoft.Web/serverfarms/hostingEnvironmentProfile.id",
                                            "equals": "[parameters('hostingEnvironmentProfileID')]"
                                        }
                                    ]
                                }
                            }
                        ]
                    },
                    "then": {
                        "effect": "deny"
                    }
                }
            }
        }

