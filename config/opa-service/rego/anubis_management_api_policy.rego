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

# Set the header link for the policies
header_link = link {
  current_path := split(request.resource, "/")
  current_path[2] == "policies"
  current_path[3]
  not current_path[3] == ""
  link := sprintf("<%s?resource=%s&&type=%s>; rel=\"acl\"", [api_uri,current_path[3],"policy"])
}
header_link = link {
  current_path := split(request.resource, "/")
  current_path[2] == "policies"
  current_path[3] == ""
  link := sprintf("<%s?resource=%s&&type=%s>; rel=\"acl\"", [api_uri,"*","policy"])
}
header_link = link {
  current_path := split(request.resource, "/")
  current_path[2] == "policies"
  not current_path[3]
  link := sprintf("<%s?resource=%s&&type=%s>; rel=\"acl\"", [api_uri,"*","policy"])
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

# Set the header link for the tenants
header_link = link {
  current_path := split(request.resource, "/")
  current_path[2] == "tenants"
  current_path[3]
  not current_path[3] == ""
  not current_path[4]
  link := sprintf("<%s?resource=%s&&type=%s>; rel=\"acl\"", [api_uri,current_path[3],"tenant"])
}
header_link = link {
  current_path := split(request.resource, "/")
  current_path[2] == "tenants"
  current_path[3] == ""
  link := sprintf("<%s?resource=%s&&type=%s>; rel=\"acl\"", [api_uri,"*","tenant"])
}
header_link = link {
  current_path := split(request.resource, "/")
  current_path[2] == "tenants"
  not current_path[3]
  link := sprintf("<%s?resource=%s&&type=%s>; rel=\"acl\"", [api_uri,"*","tenant"])
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

# Set the header link for the service paths
header_link = link {
  current_path := split(request.resource, "/")
  current_path[2] == "tenants"
  current_path[3]
  not current_path[3] == ""
  current_path[4] == "service_paths"
  current_path[5]
  not current_path[5] == ""
  current_service_path_array := array.concat([""],array.slice(current_path, 5, count(current_path)))
  current_service_path := concat("/",current_service_path_array)
  link := sprintf("<%s?resource=%s&&type=%s>; rel=\"acl\"", [api_uri,current_service_path,"service_path"])
}
header_link = link {
  current_path := split(request.resource, "/")
  current_path[2] == "tenants"
  current_path[3]
  not current_path[3] == ""
  current_path[4] == "service_paths"
  not current_path[5]
  link := sprintf("<%s?resource=%s&&type=%s>; rel=\"acl\"", [api_uri,"*","service_path"])
}
header_link = link {
  current_path := split(request.resource, "/")
  current_path[2] == "tenants"
  current_path[3]
  not current_path[3] == ""
  current_path[4] == "service_paths"
  current_path[5] == ""
  link := sprintf("<%s?resource=%s&&type=%s>; rel=\"acl\"", [api_uri,"*","service_path"])
}
