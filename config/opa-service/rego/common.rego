package envoy.authz

import future.keywords.in

import input.attributes.request.http.method as method
import input.attributes.request.http.path as path
import input.attributes.request.http.headers.authorization as authorization
import input.parsed_body as parsed_body

# Action to method mappings
scope_method := {"acl:Read": ["GET"], "acl:Append": ["POST", "PATCH"], "acl:Write": ["POST", "PUT", "DELETE", "PATCH"], "acl:Control": ["CONTROL"]}

# Extract Bearer Token
bearer_token = t {
	v := authorization
	startswith(v, "Bearer ")
	t := substring(v, count("Bearer "), -1)
}

# Helper to get the token payload
token = {"payload": payload, "header": header} {
  [header, payload, signature] := io.jwt.decode(bearer_token)
}

# Valid Issuers
valid_iss = split(opa.runtime()["env"]["VALID_ISSUERS"], ";")

# API URI
api_uri = opa.runtime()["env"]["AUTH_API_URI"]

# Audience
aud = opa.runtime()["env"]["VALID_AUDIENCE"]

# Token issuer
issuer = token.payload.iss

# Get token metadata
metadata = http.send({
    "url": concat("", [issuer, "/.well-known/openid-configuration"]),
    "method": "GET",
    "force_cache": true,
    "force_cache_duration_seconds": 86400
}).body

# Get endpoints for jws and the token
jwks_endpoint := metadata.jwks_uri
token_endpoint := metadata.token_endpoint

# jwks_request for validation
jwks_request(url) = http.send({
    "url": url,
    "method": "GET",
    "force_cache": true,
    "force_cache_duration_seconds": 3600
})

# Grab data from API
data = http.send({"method": "get", "url": api_uri, "headers": {"accept": "text/rego", "fiware-service": request.tenant, "fiware-servicepath": request.service_path}}).body

# The user/subject
subject := p {
	p := token.payload.email
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

# Compute link
default header_link = ""

# Compute service
default service = "None"

# Auth defaults to false
default allow = {
    "allowed": false,
}

# Auth main rule
allow = response {
		response := {
        "allowed": check_policy,
        "response_headers_to_add": {"Link": header_link}
    }
}

# Check policy when accessing resources
check_policy {
	current_path := split(request.resource, "/")
	current_path[2] != "policies"
	user_permitted(request)
}

# Check for token validity
is_token_valid {
  now = time.now_ns() / 1000000000
  token.payload.exp >= now
  jwks = json.marshal(jwks_request(jwks_endpoint).body.keys[_])
  io.jwt.verify_rs256(bearer_token, jwks)
	token.payload.azp = aud
	issuer = valid_iss[_]
}

# Token valid when testing (default is false)
testing = false
is_token_valid {
  testing
}

# Check if service path in policy is equal to the request path
service_path_matches_policy(entry_path, request_path) {
	entry_path == request_path
}

# Check if service path in policy is the wildcard, thus matching any path
service_path_matches_policy(entry_path, request_path) {
	entry_path == "*"
}

# Check if service path in policy is equal to the request path, and matching any
# subpath as well
service_path_matches_default_policy(entry_path, request_path) {
	split_entry_path := split(entry_path, "/")
	split_request_path := split(request_path, "/")
	not arrays_dont_have_same_value(split_entry_path, split_request_path)
}

# Check if service path in policy is equal to the request path, with / matching
# all subpaths
service_path_matches_default_policy(entry_path, request_path) {
	entry_path == "/"
}

arrays_dont_have_same_value(a, b) {
	some i, _ in a
	a[i] != b[i]
}

method_matches_action(entry, request) {
	scope_method[entry.action][_] == request.action
}

default user_permitted(request) = false

# User permissions
user_permitted(request) {
  is_token_valid
  entry := data.user_permissions[request.user][_]
  method_matches_action(entry, request)
  path_matches_policy(entry, request)
  entry.tenant == request.tenant
  service_path_matches_policy(entry.service_path, request.service_path)
}

# Default User permissions
user_permitted(request) {
  is_token_valid
  entry := data.default_user_permissions[request.user][_]
  method_matches_action(entry, request)
	path_matches_policy(entry, request)
  entry.tenant == request.tenant
  service_path_matches_default_policy(entry.service_path, request.service_path)
}

# Group permissions
user_permitted(request) {
  is_token_valid
  some tenant_i
  token.payload.tenants[tenant_i].name == request.tenant
  entry := data.group_permissions[token.payload.tenants[tenant_i].groups[_].name][_]
  method_matches_action(entry, request)
  path_matches_policy(entry, request)
  entry.tenant == request.tenant
  service_path_matches_policy(entry.service_path, request.service_path)
}

# Default Group permissions
user_permitted(request) {
  is_token_valid
  some tenant_i
  token.payload.tenants[tenant_i].name == request.tenant
  entry := data.default_group_permissions[token.payload.tenants[tenant_i].groups[_].name][_]
  method_matches_action(entry, request)
	path_matches_policy(entry, request)
  entry.tenant == request.tenant
  service_path_matches_default_policy(entry.service_path, request.service_path)
}

# Role permissions
user_permitted(request) {
  is_token_valid
  some tenant_i
  token.payload.tenants[tenant_i].name == request.tenant
  entry := data.role_permissions[token.payload.tenants[tenant_i].groups[_].clientRoles[_]][_]
  method_matches_action(entry, request)
  path_matches_policy(entry, request)
  entry.tenant == request.tenant
  service_path_matches_policy(entry.service_path, request.service_path)
}

# Default Role permissions
user_permitted(request) {
  is_token_valid
  some tenant_i
  token.payload.tenants[tenant_i].name == request.tenant
  entry := data.default_role_permissions[token.payload.tenants[tenant_i].groups[_].clientRoles[_]][_]
  method_matches_action(entry, request)
	path_matches_policy(entry, request)
  entry.tenant == request.tenant
  service_path_matches_default_policy(entry.service_path, request.service_path)
}

# AuthenticatedAgent special permission
user_permitted(request) {
  is_token_valid
  some role
  entry := data.role_permissions[role][_]
  role == "AuthenticatedAgent"
  method_matches_action(entry, request)
  path_matches_policy(entry, request)
  entry.tenant == request.tenant
  service_path_matches_policy(entry.service_path, request.service_path)
}

# Default AuthenticatedAgent special permission
user_permitted(request) {
  is_token_valid
  some role
  entry := data.default_role_permissions[role][_]
  role == "AuthenticatedAgent"
  method_matches_action(entry, request)
	path_matches_policy(entry, request)
  entry.tenant == request.tenant
  service_path_matches_default_policy(entry.service_path, request.service_path)
}

# Agent special permission
user_permitted(request) {
  some role
  entry := data.role_permissions[role][_]
  role == "Agent"
  method_matches_action(entry, request)
  path_matches_policy(entry, request)
  entry.tenant == request.tenant
  service_path_matches_policy(entry.service_path, request.service_path)
}

# Default Agent special permission
user_permitted(request) {
  some role
  entry := data.default_role_permissions[role][_]
  role == "Agent"
  method_matches_action(entry, request)
	path_matches_policy(entry, request)
  entry.tenant == request.tenant
  service_path_matches_default_policy(entry.service_path, request.service_path)
}
