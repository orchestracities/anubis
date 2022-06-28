package system.log

method_to_mode := {
  "GET": "acl:Read",
  "PATCH": "acl:Append",
  "POST": "acl:Write",
  "PUT": "acl:Write",
  "DELETE": "oc-acl:Delete"
}

# Anubis - service
mask[{"op": "upsert", "path": "/input/service", "value": x}] {
  current_path := split(input.input.attributes.request.http.path, "/")
  current_path[2] == "policies"
  x := "auth management"
}

# Anubis - resource
mask[{"op": "upsert", "path": "/input/resource", "value": x}] {
  current_path := split(input.input.attributes.request.http.path, "/")
  current_path[2] == "policies"
  count(current_path) > 3
  x := current_path[3]
}

mask[{"op": "upsert", "path": "/input/resource", "value": x}] {
  current_path := split(input.input.attributes.request.http.path, "/")
  current_path[2] == "tenants"
  count(current_path) < 4
  x := current_path[3]
}

mask[{"op": "upsert", "path": "/input/resource", "value": x}] {
  current_path := split(input.input.attributes.request.http.path, "/")
  current_path[2] == "tenants"
  current_path[4] == "service_paths"
  count(current_path) > 5
  x := current_path[5]
}

# Anubis - resource type
mask[{"op": "upsert", "path": "/input/resource_type", "value": x}] {
  current_path := split(input.input.attributes.request.http.path, "/")
  current_path[2] == "policies"
  x := "policy"
}

mask[{"op": "upsert", "path": "/input/resource_type", "value": x}] {
  current_path := split(input.input.attributes.request.http.path, "/")
  current_path[2] == "tenants"
  current_path[4] == "service_paths"
  x := "service_path"
}

mask[{"op": "upsert", "path": "/input/resource_type", "value": x}] {
  current_path := split(input.input.attributes.request.http.path, "/")
  current_path[2] == "tenants"
  current_path[3] == "service_paths"
  x := "service_path"
}

mask[{"op": "upsert", "path": "/input/resource_type", "value": x}] {
  current_path := split(input.input.attributes.request.http.path, "/")
  current_path[2] == "tenants"
  count(current_path) < 4
  x := "tenant"
}

# NGSI v2 - service
mask[{"op": "upsert", "path": "/input/service", "value": x}] {
  current_path := split(input.input.attributes.request.http.path, "/")
  current_path[2] == "entities"
  x := "context broker"
}

mask[{"op": "upsert", "path": "/input/service", "value": x}] {
  current_path := split(input.input.attributes.request.http.path, "/")
  current_path[2] == "types"
  x := "context broker"
}

mask[{"op": "upsert", "path": "/input/service", "value": x}] {
  current_path := split(input.input.attributes.request.http.path, "/")
  current_path[2] == "subscriptions"
  x := "context broker"
}

# NGSI v2 - resource

mask[{"op": "upsert", "path": "/input/resource", "value": x}] {
  current_path := split(input.input.attributes.request.http.path, "/")
  count(current_path) > 3
  x := current_path[3]
}

# NGSI v2 - resource type

mask[{"op": "upsert", "path": "/input/resource_type", "value": x}] {
  current_path := split(input.input.attributes.request.http.path, "/")
  current_path[2] == "entities"
  x := "entity"
}

mask[{"op": "upsert", "path": "/input/resource_type", "value": x}] {
  current_path := split(input.input.attributes.request.http.path, "/")
  current_path[2] == "types"
  x := "type"
}

mask[{"op": "upsert", "path": "/input/resource_type", "value": x}] {
  current_path := split(input.input.attributes.request.http.path, "/")
  current_path[2] == "subscriptions"
  x := "subscription"
}

# Default
mask[{"op": "upsert", "path": "/input/mode", "value": x}] {
  current_method := input.input.attributes.request.http.method
  x := method_to_mode[current_method]
}

mask[{"op": "upsert", "path": "/input/mode", "value": x}] {
  x := "Unknown"
}

mask[{"op": "upsert", "path": "/input/service", "value": x}] {
  x := "Unknown"
}

mask[{"op": "upsert", "path": "/input/resource_type", "value": x}] {
  x := "Unknown"
}

mask[{"op": "upsert", "path": "/input/resource", "value": x}] {
  current_method := input.input.attributes.request.http.method
  current_method == "POST"
  x := input.input.parsed_body.id
}

mask[{"op": "upsert", "path": "/input/resource", "value": x}] {
  x := "*"
}
