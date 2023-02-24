package envoy.authz

import future.keywords.in

import input.attributes.request.http.method as method
import input.attributes.request.http.path as path
import input.attributes.request.http.headers.authorization as authorization
import input.parsed_body as parsed_body


match_policy_id_or_wildcard(e, policy_id) {
  e.id == policy_id
}
match_policy_id_or_wildcard(e, policy_id) {
  e.resource == "*"
}

# Check policy when trying to get all policies (API will filter the ones for the given user)
check_policy {
	current_path := split(request.resource, "/")
	current_path[1] == "v1"
	current_path[2] == "policies"
  request.action in ["GET"]
  current_path[3] == ""
}
check_policy {
	current_path := split(request.resource, "/")
	current_path[1] == "v1"
	current_path[2] == "policies"
  request.action in ["GET"]
  not current_path[3]
}
check_policy {
	current_path := split(path, "/")
	current_path[1] == "v1"
	current_path[2] == "policies"
  method in ["GET"]
  current_path[3] == "me"
}

# Check policy when trying to get an entity acl resource
check_policy {
	current_path := split(request.resource, "/")
	current_path[1] == "v1"
	current_path[2] == "policies"
  request.action in ["GET", "PUT", "PATCH", "DELETE"]
  policy_id := current_path[3]
  e := policies[_][_][_]
  match_policy_id_or_wildcard(e, policy_id)
  e.resource_type == "entity"
  control_request = {"user":request.user, "action": "CONTROL", "resource":concat("", ["/v2/entities/",e.resource]), "tenant":request.tenant, "service_path":request.service_path}
  user_permitted(control_request)
}

# Check policy when trying to create a new entity acl resource
check_policy {
	current_path := split(request.resource, "/")
	current_path[1] == "v1"
	current_path[2] == "policies"
  request.action == "POST"
  parsed_body.resource_type == "entity"
  control_request = {"user":request.user, "action": "CONTROL", "resource":concat("", ["/v2/entities/",parsed_body.access_to]), "tenant":request.tenant, "service_path":request.service_path}
  user_permitted(control_request)
}

# Check policy when trying to get an entity type acl resource
check_policy {
	current_path := split(request.resource, "/")
	current_path[1] == "v1"
	current_path[2] == "policies"
  request.action in ["GET", "PUT", "PATCH", "DELETE"]
  policy_id := current_path[3]
  e := policies[_][_][_]
  match_policy_id_or_wildcard(e, policy_id)
  e.resource_type == "entity_type"
  control_request = {"user":request.user, "action": "CONTROL", "resource":concat("", ["/v2/types/",e.resource]), "tenant":request.tenant, "service_path":request.service_path}
  user_permitted(control_request)
}

# Check policy when trying to access a new entity type acl resource
check_policy {
	current_path := split(request.resource, "/")
	current_path[1] == "v1"
	current_path[2] == "policies"
  request.action == "POST"
  parsed_body.resource_type == "entity_type"
  control_request = {"user":request.user, "action": "CONTROL", "resource":concat("", ["/v2/types/",parsed_body.access_to]), "tenant":request.tenant, "service_path":request.service_path}
  user_permitted(control_request)
}

# Check policy when trying to get an entity type acl resource
check_policy {
	current_path := split(request.resource, "/")
	current_path[1] == "v1"
	current_path[2] == "policies"
  request.action in ["GET", "PUT", "PATCH", "DELETE"]
  policy_id := current_path[3]
  e := policies[_][_][_]
  match_policy_id_or_wildcard(e, policy_id)
  e.resource_type == "subscriptions"
  control_request = {"user":request.user, "action": "CONTROL", "resource":concat("", ["/v2/subscription/",e.resource]), "tenant":request.tenant, "service_path":request.service_path}
  user_permitted(control_request)
}

# Check policy when trying to access a new subscription acl resource
check_policy {
	current_path := split(request.resource, "/")
	current_path[1] == "v1"
	current_path[2] == "policies"
  request.action == "POST"
  parsed_body.resource_type == "subscriptions"
  control_request = {"user":request.user, "action": "CONTROL", "resource":concat("", ["/v2/subscriptions/",parsed_body.access_to]), "tenant":request.tenant, "service_path":request.service_path}
  user_permitted(control_request)
}

######################################################################################################

# Checks if the policy has the wildcard asterisks, thus matching paths to any policy or all
path_matches_policy(entry, request) {
  entry.resource == "*"
	entry.resource_type == "policy"
  current_path := split(request.resource, "/")
  current_path[1] == "v1"
  current_path[2] == "policies"
}

# Checks if the policy is a default
path_matches_policy(entry, request) {
  entry.resource == "default"
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
  link := sprintf("<%s/me?resource=%s&&type=%s>; rel=\"acl\"", [api_uri,current_path[3],"policy"])
}
header_link = link {
  current_path := split(request.resource, "/")
  current_path[2] == "policies"
  current_path[3] == ""
  link := sprintf("<%s/me?resource=%s&&type=%s>; rel=\"acl\"", [api_uri,"*","policy"])
}
header_link = link {
  current_path := split(request.resource, "/")
  current_path[2] == "policies"
  current_path[3] == "me"
  link := sprintf("<%s/me?resource=%s&&type=%s>; rel=\"acl\"", [api_uri,"*","policy"])
}
header_link = link {
  current_path := split(request.resource, "/")
  current_path[2] == "policies"
  not current_path[3]
  link := sprintf("<%s/me?resource=%s&&type=%s>; rel=\"acl\"", [api_uri,"*","policy"])
}

# Checks if the policy has the wildcard asterisks, thus matching paths to any tenant or all
path_matches_policy(entry, request) {
  entry.resource == "*"
	entry.resource_type == "tenant"
  current_path := split(request.resource, "/")
  current_path[1] == "v1"
  current_path[2] == "tenants"
}

# Checks if the policy is a default
path_matches_policy(entry, request) {
  entry.resource == "default"
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
  link := sprintf("<%s/me?resource=%s&&type=%s>; rel=\"acl\"", [api_uri,current_path[3],"tenant"])
}
header_link = link {
  current_path := split(request.resource, "/")
  current_path[2] == "tenants"
  current_path[3] == ""
  link := sprintf("<%s/me?resource=%s&&type=%s>; rel=\"acl\"", [api_uri,"*","tenant"])
}
header_link = link {
  current_path := split(request.resource, "/")
  current_path[2] == "tenants"
  not current_path[3]
  link := sprintf("<%s/me?resource=%s&&type=%s>; rel=\"acl\"", [api_uri,"*","tenant"])
}

# Checks if the policy has the wildcard asterisks, thus matching paths to any tenant or all
path_matches_policy(entry, request) {
  entry.resource == "*"
	entry.resource_type == "service_path"
  current_path := split(request.resource, "/")
  current_path[1] == "v1"
  current_path[2] == "tenants"
  current_path[3] == entry.tenant
  current_path[4] == "service_paths"
}

# Checks if the policy is a default
path_matches_policy(entry, request) {
  entry.resource == "default"
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
  link := sprintf("<%s/me?resource=%s&&type=%s>; rel=\"acl\"", [api_uri,current_service_path,"service_path"])
}
header_link = link {
  current_path := split(request.resource, "/")
  current_path[2] == "tenants"
  current_path[3]
  not current_path[3] == ""
  current_path[4] == "service_paths"
  not current_path[5]
  link := sprintf("<%s/me?resource=%s&&type=%s>; rel=\"acl\"", [api_uri,"*","service_path"])
}
header_link = link {
  current_path := split(request.resource, "/")
  current_path[2] == "tenants"
  current_path[3]
  not current_path[3] == ""
  current_path[4] == "service_paths"
  current_path[5] == ""
  link := sprintf("<%s/me?resource=%s&&type=%s>; rel=\"acl\"", [api_uri,"*","service_path"])
}
