package envoy.authz

import future.keywords.in

import input.attributes.request.http.method as method
import input.attributes.request.http.path as path
import input.attributes.request.http.headers.authorization as authorization


# Checks if the policy has the wildcard asterisks, thus matching paths to any policy or all
path_matches_policy(entry, request) {
  entry.resource == "*"
	entry.resource_type == "policy"
  current_path := split(request.resource, "/")
  current_path[1] == "v1"
  current_path[2] == "policies"
}

# Checks if the policy targetted by this policy matches the path
path_matches_policy(entry, request) {
	entry.resource_type == "policy"
  current_path := split(request.resource, "/")
  current_path[1] == "v1"
  current_path[2] == "policies"
  current_path[3] == entry.resource
}

# Checks if the tenant has the wildcard asterisks, thus matching paths to any tenant or all
path_matches_policy(entry, request) {
  entry.resource == "*"
	entry.resource_type == "tenant"
  current_path := split(request.resource, "/")
  current_path[1] == "v1"
  current_path[2] == "tenants"
}

# Checks if the tenant in the policy matches the path
path_matches_policy(entry, request) {
	entry.resource_type == "tenant"
  current_path := split(request.resource, "/")
  current_path[1] == "v1"
  current_path[2] == "tenants"
  current_path[3] == entry.resource
}

# Checks if the tenant has the wildcard asterisks, thus matching paths to any tenant or all
path_matches_policy(entry, request) {
  entry.resource == "*"
	entry.resource_type == "service_path"
  current_path := split(request.resource, "/")
  current_path[1] == "v1"
  current_path[2] == "tenants"
  current_path[3] == entry.tenant
  current_path[4] == "service_paths"
}

# Checks if the tenant in the policy matches the path
path_matches_policy(entry, request) {
	entry.resource_type == "service_path"
  current_path := split(request.resource, "/")
  current_path[1] == "v1"
  current_path[2] == "tenants"
  current_path[3] == entry.tenant
  current_path[4] == "service_paths"
	split_request_path := split(entry.resource, "/")
	not arrays_dont_have_same_value(array.slice(current_path, 5, count(current_path)), array.slice(split_request_path, 1, count(split_request_path)))
}
