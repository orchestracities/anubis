# How to customize Anubis

## Adding new action types

At the time being we support the actions defined by Web Access Control ontology
and the custom action `oc-acl:Delete`.

To add additional action types, you need to:

1. Extend the [oc-acl vocabulary](https://github.com/orchestracities/anubis/blob/master/oc-acl.ttl).
1. Extend `default` values in the Anubis Management API [code](https://github.com/orchestracities/anubis/blob/master/anubis-management-api/src/default.py)
and the default database population in the policy [model](https://github.com/orchestracities/anubis/blob/master/anubis-management-api/src/policies/models.py#L87).
1. In case special validation is required, you should also modify the policy [schema](https://github.com/orchestracities/anubis/blob/master/anubis-management-api/src/policies/schemas.py).
1. Customize the rego action to http method [mapping](https://github.com/orchestracities/anubis/blob/master/config/opa-service/rego/common.rego#L11)

## Adding new actor types

At the time being we support the actor types defined by Web Access Control ontology
and the custom actor `oc-acl:ResourceTenantAgent`.

To add additional actor types, you need to:

1. Extend the [oc-acl vocabulary](https://github.com/orchestracities/anubis/blob/master/oc-acl.ttl).
1. Extend `default` values in the Anubis Management API [code](https://github.com/orchestracities/anubis/blob/master/anubis-management-api/src/default.py).
1. Modify the policy [operations](https://github.com/orchestracities/anubis/blob/master/anubis-management-api/src/policies/operations.py)
    and [model](https://github.com/orchestracities/anubis/blob/master/anubis-management-api/src/policies/models.py#L69).
1. Customize [rego serialization](https://github.com/orchestracities/anubis/blob/master/anubis-management-api/src/rego.py)
    as needed.
1. Customize [WAC parsing and serialization](https://github.com/orchestracities/anubis/blob/master/anubis-management-api/src/wac.py)
    as needed.
1. Customize rego rules as needed.

## Protecting new APIs

To protect a new API, you need to:

1. Develop a rego document that maps access control policies to the specs of
the API.

1. Develop a custom lua script that automates the creation of policies at
resource creation time.

### Creating a custom rego

Specific rules are defined based on the spec of the API to protect, e.g.:

    :::javascript
    # Checks if the entity in the policy matches the path
    path_matches_policy(resource, resource_type, path) {
      resource_type = "entity"
      current_path := split(path, "/")
      current_path[1] == "v2"
      current_path[2] == "entities"
      current_path[3] == resource
    }

    # User permissions
    user_permitted {
      is_token_valid
      entry := data.user_permissions[token.payload.sub][_]
      scope_method[entry.action][_] == request.action
      path_matches_policy(entry.resource, entry.resource_type, request.resource)
      entry.tenant == request.tenant
      entry.service_path == request.service_path
    }

In this case, the `path_matches_policy` check if a the incoming request has a
given format, while `user_permitted` checks if according to the user based
access policies, the request is allowed.

### Creating a custom lua script to automate policy creation at resource creation

TBD

## Customize authentication

TBD
