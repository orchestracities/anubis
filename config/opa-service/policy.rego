package envoy.authz.tenant1

import input.attributes.request.http.method as method
import input.attributes.request.http.path as path
import input.attributes.request.http.headers.authorization as authorization

scope_method = {"entity:read": "GET", "entity:create": "POST", "entity:delete": "DELETE"}

# Helper to get the token payload.
token = {"payload": payload} {
  [header, payload, signature] := io.jwt.decode(bearer_token)
}


roles = { "631a780d-c7a2-4b6a-acd8-e856348bcb2e" : ["admin", "super_hero"]}

groups = { "631a780d-c7a2-4b6a-acd8-e856348bcb2e" : ["/EKZ/admin", "/EKZ/super_hero"]}

default authz = false

authz {
    allow
    not deny
}

default resource_allowed = false

allow {
    is_token_valid
    resource_allowed
}

deny {
    resource_denied
}

is_token_valid {
  now := time.now_ns() / 1000000000
  token.payload.nbf <= now
  #now < token.payload.exp
}

bearer_token := t {
	# Bearer tokens are contained inside of the HTTP Authorization header. This rule
	# parses the header and extracts the Bearer token value. If no Bearer token is
	# provided, the `bearer_token` value is undefined.
	v := authorization
	startswith(v, "Bearer ")
	t := substring(v, count("Bearer "), -1)
}

contains_element(arr, elem) = true {
    arr[_] = elem
} else = false { true }

subject := p {
	p := token.payload.sub
}

fiware_service := p {
	p := input.attributes.request.http.headers["fiware-service"]
}

fiware_servicepath := p {
	p := input.attributes.request.http.headers["fiware-servicepath"]
}

#list all entities
resource_allowed {
    #role based policy
    roles[subject][i] = "admin"
    #is the resource allowed?
    glob.match("/v2/entities", ["/"], path)
    #is the action allowed?
    scope_method["entity:read"] = method
    fiware_service = "EKZ"
    glob.match("/**", ["/"], fiware_servicepath)
}

#create entities
resource_allowed {
    #group based policy
    groups[subject][i] == "/EKZ/admin"
   	#is the resource allowed?
    glob.match("/v2/entities", ["/"], path)
    #is the action allowed?
    scope_method["entity:create"] = method
    fiware_service = "EKZ"
    glob.match("/Path1/Path2", ["/"], fiware_servicepath)
}

#read entities
resource_allowed {
    "631a780d-c7a2-4b6a-acd8-e856348bcb2e" = subject
    glob.match("/v2/entities/*", ["/"], path)
    #is the action allowed?
    scope_method["entity:read"] = method
    fiware_service = "EKZ"
    glob.match("/**", ["/"], fiware_servicepath)
}


#read entities attributes
resource_allowed {
    "631a780d-c7a2-4b6a-acd8-e856348bcb2e" = subject
    glob.match("/v2/entities/*/attrs", ["/"], path)
    #is the action allowed?
    scope_method["entity:read"] = method
    fiware_service = "EKZ"
    glob.match("/**", ["/"], fiware_servicepath)
}

#read all entities attributes
resource_allowed { 
    "631a780d-c7a2-4b6a-acd8-e856348bcb2e" = subject
    glob.match("/v2/entities/*/attrs/*", ["/"], path)
    #is the action allowed?
    scope_method["entity:read"] = method
    fiware_service = "EKZ"
    glob.match("/**", ["/"], fiware_servicepath)
}

#read is public!
resource_allowed {
    glob.match("/v2/entities/ent1", ["/"], path)
    #is the action allowed?
    scope_method["entity:read"] = method
    fiware_service = "EKZ"
    glob.match("/Path1/Path2", ["/"], fiware_servicepath)
}

#deny read entities
resource_denied {
    "631a780d-c7a2-4b6a-acd8-e856348bcb2e" = subject
    glob.match("/v2/entities/ent2", ["/"], path)
    #is the action allowed?
    scope_method["entity:read"] = method
    fiware_service = "EKZ"
    glob.match("/Path1/Path2", ["/"], fiware_servicepath)
}