package envoy.authz.tenant1

import input.attributes.request.http.method as method
import input.attributes.request.http.path as path
import input.attributes.request.http.headers.authorization as authorization

# Auth defaults to false
default authz = false

# Action to method mappings
scope_method = {"acl:Read": "GET", "acl:Write": "POST", "entity:Control": "PUT", "entity:Control": "DELETE"}

# Helper to get the token payload
token = {"payload": payload} {
  [header, payload, signature] := io.jwt.decode(bearer_token)
}

# Auth main rule
authz {
  is_token_valid
  user_permitted
}

# Check for token validity
is_token_valid {
  now := time.now_ns() / 1000000000
  token.payload.nbf <= now
}

# User permissions
user_permitted {
  scope_method[data.user_permissions[token.payload.sub][_].action] == input.action
  data.user_permissions[token.payload.sub][_].resource == input.resource
  data.user_permissions[token.payload.sub][_].tenant == input.tenant
  data.user_permissions[token.payload.sub][_].servicePath == input.servicePath
}

# Group permissions
user_permitted {
  scope_method[data.group_permissions[token.payload.tenants[_].groups[_].name][_].action] == input.action
  data.group_permissions[token.payload.tenants[_].groups[_].name][_].resource == input.resource
  data.group_permissions[token.payload.tenants[_].groups[_].name][_].tenant == input.tenant
  data.group_permissions[token.payload.tenants[_].groups[_].name][_].servicePath == input.servicePath
}

# Role permissions
user_permitted {
  scope_method[data.role_permissions[token.payload.tenant_roles[_].roles[_]][_].action] == input.action
  data.role_permissions[token.payload.tenant_roles[_].roles[_]][_].resource == input.resource
  data.role_permissions[token.payload.tenant_roles[_].roles[_]][_].tenant == input.tenant
  data.role_permissions[token.payload.tenant_roles[_].roles[_]][_].servicePath == input.servicePath
}
