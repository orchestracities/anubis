package envoy.authz

import future.keywords.in

import input.attributes.request.http.method as method
import input.attributes.request.http.path as path
import input.attributes.request.http.headers.authorization as authorization


# Checks if the policy has the wildcard asterisks, thus matching paths to any policy or all
path_matches_policy(resource, resource_type, path) {
  resource == "*"
	resource_type == "policy"
  current_path := split(path, "/")
  current_path[1] == "v1"
  current_path[2] == "policies"
}

# Checks if the entity in the policy matches the path
path_matches_policy(resource, resource_type, path) {
	resource_type == "policy"
  current_path := split(path, "/")
  current_path[1] == "v1"
  current_path[2] == "policies"
  current_path[3] == resource
}
