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
  token.payload.nbf <= now
}

# User permissions
user_permitted {
  is_token_valid
  scope_method[data.user_permissions[token.payload.sub][_].action][_] == request.action
  data.user_permissions[token.payload.sub][_].resource == request.resource
  data.user_permissions[token.payload.sub][_].tenant == request.tenant
  data.user_permissions[token.payload.sub][_].service_path == request.service_path
}

# Group permissions
user_permitted {
  is_token_valid
  some tenant_i
  token.payload.tenants[tenant_i].name == request.tenant
  scope_method[data.group_permissions[token.payload.tenants[tenant_i].groups[_].name][_].action][_] == request.action
  data.group_permissions[token.payload.tenants[tenant_i].groups[_].name][_].resource == request.resource
  data.group_permissions[token.payload.tenants[tenant_i].groups[_].name][_].tenant == request.tenant
  data.group_permissions[token.payload.tenants[tenant_i].groups[_].name][_].service_path == request.service_path
}

# Role permissions
user_permitted {
  is_token_valid
  some tenant_i
  token.payload.tenant_roles[tenant_i].name == request.tenant
  scope_method[data.role_permissions[token.payload.tenant_roles[_].roles[_]][_].action][_] == request.action
  data.role_permissions[token.payload.tenant_roles[tenant_i].roles[_]][_].resource == request.resource
  data.role_permissions[token.payload.tenant_roles[tenant_i].roles[_]][_].tenant == request.tenant
  data.role_permissions[token.payload.tenant_roles[tenant_i].roles[_]][_].service_path == request.service_path
}

# AuthenticatedAgent special permission
user_permitted {
  is_token_valid
  some role
  role == "AuthenticatedAgent"
  scope_method[data.role_permissions[role][_].action][_] == request.action
  data.role_permissions[role][_].resource == request.resource
  data.role_permissions[role][_].tenant == request.tenant
  data.role_permissions[role][_].service_path == request.service_path
}

# Agent special permission
user_permitted {
  some role
  role == "Agent"
  scope_method[data.role_permissions[role][_].action][_] == request.action
  data.role_permissions[role][_].resource == request.resource
  data.role_permissions[role][_].tenant == request.tenant
  data.role_permissions[role][_].service_path == request.service_path
}
