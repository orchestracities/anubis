# How to customize Anubis

## Adding new actions

TBD

## Protecting new APIs

TBD

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

### Customize authentication

TBD
