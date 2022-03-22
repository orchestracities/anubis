package envoy.authz

import future.keywords.in

import input.attributes.request.http.method as method
import input.attributes.request.http.path as path
import input.attributes.request.http.headers.authorization as authorization

# Checks if the policy has the wildcard asterisks, thus matching paths to any entity or all
path_matches_policy(resource, resource_type, path) {
  resource == "*"
  resource_type == "entity"
  current_path := split(path, "/")
  current_path[1] == "v2"
  current_path[2] == "entities"
}

# Checks if the entity in the policy matches the path
path_matches_policy(resource, resource_type, path) {
  resource_type == "entity"
  current_path := split(path, "/")
  current_path[1] == "v2"
  current_path[2] == "entities"
  current_path[3] == resource
}

# Checks if the policy has the wildcard asterisks, thus matching paths to any entity types or all
path_matches_policy(resource, resource_type, path) {
  resource == "*"
  resource_type == "entity_type"
  current_path := split(path, "/")
  current_path[1] == "v2"
  current_path[2] == "types"
}

# Checks if the entity type in the policy matches the path
path_matches_policy(resource, resource_type, path) {
  resource_type == "entity_type"
  current_path := split(path, "/")
  current_path[1] == "v2"
  current_path[2] == "types"
  current_path[3] == resource
}

# Checks if the policy has the wildcard asterisks, thus matching paths to any subscription or all
path_matches_policy(resource, resource_type, path) {
  resource == "*"
  resource_type == "subscription"
  current_path := split(path, "/")
  current_path[1] == "v2"
  current_path[2] == "subscriptions"
}

# Checks if the subscription in the policy matches the path
path_matches_policy(resource, resource_type, path) {
  resource_type == "subscription"
  current_path := split(path, "/")
  current_path[1] == "v2"
  current_path[2] == "subscriptions"
  current_path[3] == resource
}
