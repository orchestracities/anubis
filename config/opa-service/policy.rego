package envoy.authz

import input.attributes.request.http.method as method
import input.attributes.request.http.path as path
import input.attributes.request.http.headers.authorization as authorization

# Auth defaults to false
default authz = false

# Action to method mappings
scope_method := {"acl:Read": ["GET"], "acl:Write": ["POST"], "acl:Control": ["PUT", "DELETE"]}

# Helper to get the token payload
token = {"payload": payload} {
  [header, payload, signature] := io.jwt.decode(bearer_token)
}

# Extract Bearer Token
bearer_token = t {
	v := authorization
	startswith(v, "Bearer ")
	t := substring(v, count("Bearer "), -1)
}

# API URI
api_uri = "http://policy-api:8000/v1/policies/"

# Grab data from API
data = http.send({"method": "get", "url": api_uri, "headers": {"accept": "text/rego", "fiware_service": request.tenant, "fiware_service_path": request.service_path}}).body

# The user/subject
subject := p {
	p := token.payload.sub
}

# Fiware service
fiware_service := p {
	p := input.attributes.request.http.headers["fiware-service"]
}

# Fiware servicepath
fiware_servicepath := p {
	p := input.attributes.request.http.headers["fiware-servicepath"]
}

# Request data
request = {"user":subject, "action": method, "resource":path, "tenant":fiware_service, "service_path":fiware_servicepath}

# Auth main rule
authz {
  user_permitted
}

default user_permitted = false

# Check for token validity
is_token_valid {
  now := time.now_ns() / 1000000000
  token.payload.exp >= now
}

# Token valid when testing (default is false)
testing = false
is_token_valid {
  testing
}

# Checks if the policy has the wildcard asterisks, thus matching paths to any entity or all
path_matches_policy(resource, resource_type, path) {
  resource = "*"
  resource_type = "entity"
  current_path := split(path, "/")
  current_path[1] == "v2"
  current_path[2] == "entities"
}

# Checks if the entity in the policy matches the path
path_matches_policy(resource, resource_type, path) {
  resource_type = "entity"
  current_path := split(path, "/")
  current_path[1] == "v2"
  current_path[2] == "entities"
  current_path[3] == resource
}

# Checks if the policy has the wildcard asterisks, thus matching paths to any entity types or all
path_matches_policy(resource, resource_type, path) {
  resource = "*"
  resource_type = "entity_type"
  current_path := split(path, "/")
  current_path[1] == "v2"
  current_path[2] == "types"
}

# Checks if the entity type in the policy matches the path
path_matches_policy(resource, resource_type, path) {
  resource_type = "entity_type"
  current_path := split(path, "/")
  current_path[1] == "v2"
  current_path[2] == "types"
  current_path[3] == resource
}

# Checks if the policy has the wildcard asterisks, thus matching paths to any subscription or all
path_matches_policy(resource, resource_type, path) {
  resource = "*"
  resource_type = "subscription"
  current_path := split(path, "/")
  current_path[1] == "v2"
  current_path[2] == "subscriptions"
}

# Checks if the subscription in the policy matches the path
path_matches_policy(resource, resource_type, path) {
  resource_type = "subscription"
  current_path := split(path, "/")
  current_path[1] == "v2"
  current_path[2] == "subscriptions"
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

# Group permissions
user_permitted {
  is_token_valid
  some tenant_i
  token.payload.tenants[tenant_i].name == request.tenant
  entry := data.group_permissions[token.payload.tenants[tenant_i].groups[_].name][_]
  scope_method[entry.action][_] == request.action
  path_matches_policy(entry.resource, entry.resource_type, request.resource)
  entry.tenant == request.tenant
  entry.service_path == request.service_path
}

# Role permissions
user_permitted {
  is_token_valid
  some tenant_i
  token.payload.tenants[tenant_i].name == request.tenant
  entry := data.role_permissions[token.payload.tenants[tenant_i].groups[_].clientRoles[_]][_]
  scope_method[entry.action][_] == request.action
  path_matches_policy(entry.resource, entry.resource_type, request.resource)
  entry.tenant == request.tenant
  entry.service_path == request.service_path
}

# AuthenticatedAgent special permission
user_permitted {
  is_token_valid
  some role
  entry := data.role_permissions[role][_]
  role == "AuthenticatedAgent"
  scope_method[entry.action][_] == request.action
  path_matches_policy(entry.resource, entry.resource_type, request.resource)
  entry.tenant == request.tenant
  entry.service_path == request.service_path
}

# Agent special permission
user_permitted {
  some role
  entry := data.role_permissions[role][_]
  role == "Agent"
  scope_method[entry.action][_] == request.action
  path_matches_policy(entry.resource, entry.resource_type, request.resource)
  entry.tenant == request.tenant
  entry.service_path == request.service_path
}
