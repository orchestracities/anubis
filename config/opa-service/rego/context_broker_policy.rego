package envoy.authz

import future.keywords.in

import input.attributes.request.http.method as method
import input.attributes.request.http.path as path
import input.attributes.request.http.headers.authorization as authorization


# Checks if the policy has the wildcard asterisks, thus matching paths to any entity or all
path_matches_policy(entry, request) {
  entry.resource == "*"
  entry.resource_type == "entity"
  current_path := split(request.resource, "/")
  current_path[1] == "v2"
  current_path[2] == "entities"
  not entry.constraint
}

# Checks if the policy is a default
path_matches_policy(entry, request) {
  entry.resource == "default"
  entry.resource_type == "entity"
  current_path := split(request.resource, "/")
  current_path[1] == "v2"
  current_path[2] == "entities"
}

# Checks if the entity in the policy matches the path
path_matches_policy(entry, request) {
  entry.resource_type == "entity"
  current_path := split(request.resource, "/")
  current_path[1] == "v2"
  current_path[2] == "entities"
  current_path[3] == entry.resource
  not entry.constraint
}

path_matches_policy(entry, request) {
  entry.resource_type == "entity"
  current_path := split(request.resource, "/")
  current_path[1] == "v2"
  current_path[2] == "entities"
  current_path[3] == entry.resource
  constraints := split(entry.constraint, " ")
  constraints[0] == "acl-oc:ResourceName"
  check_constraint(current_path[3], constraints[1], constraints[2])
}

# Set the header link for the entities
header_link = link {
  current_path := split(request.resource, "/")
  current_path[2] == "entities"
  current_path[3]
  not current_path[3] == ""
  link := sprintf("<%s/me?resource=%s&&type=%s>; rel=\"acl\"", [api_uri,current_path[3],"entity"])
}
header_link = link {
  current_path := split(request.resource, "/")
  current_path[2] == "entities"
  current_path[3] == ""
  link := sprintf("<%s/me?resource=%s&&type=%s>; rel=\"acl\"", [api_uri,"*","entity"])
}
header_link = link {
  current_path := split(request.resource, "/")
  current_path[2] == "entities"
  not current_path[3]
  link := sprintf("<%s/me?resource=%s&&type=%s>; rel=\"acl\"", [api_uri,"*","entity"])
}

# Checks if the policy has the wildcard asterisks, thus matching paths to any entity types or all
path_matches_policy(entry, request) {
  entry.resource == "*"
  entry.resource_type == "entity_type"
  current_path := split(request.resource, "/")
  current_path[1] == "v2"
  current_path[2] == "types"
}

# Checks if the policy is a default
path_matches_policy(entry, request) {
  entry.resource == "default"
  entry.resource_type == "entity_type"
  current_path := split(request.resource, "/")
  current_path[1] == "v2"
  current_path[2] == "types"
}

# Checks if the entity type in the policy matches the path
path_matches_policy(entry, request) {
  entry.resource_type == "entity_type"
  current_path := split(request.resource, "/")
  current_path[1] == "v2"
  current_path[2] == "types"
  current_path[3] == entry.resource
}

# Set the header link for the entity types
header_link = link {
  current_path := split(request.resource, "/")
  current_path[2] == "types"
  current_path[3]
  not current_path[3] == ""
  link := sprintf("<%s/me?resource=%s&&type=%s>; rel=\"acl\"", [api_uri,current_path[3],"entity_type"])
}
header_link = link {
  current_path := split(request.resource, "/")
  current_path[2] == "types"
  current_path[3] == ""
  link := sprintf("<%s/me?resource=%s&&type=%s>; rel=\"acl\"", [api_uri,"*","entity_type"])
}
header_link = link {
  current_path := split(request.resource, "/")
  current_path[2] == "types"
  not current_path[3]
  link := sprintf("<%s/me?resource=%s&&type=%s>; rel=\"acl\"", [api_uri,"*","entity_type"])
}

# Checks if the policy has the wildcard asterisks, thus matching paths to any subscription or all
path_matches_policy(entry, request) {
  entry.resource == "*"
  entry.resource_type == "subscription"
  current_path := split(request.resource, "/")
  current_path[1] == "v2"
  current_path[2] == "subscriptions"
}

# Checks if the policy is a default
path_matches_policy(entry, request) {
  entry.resource == "default"
  entry.resource_type == "subscription"
  current_path := split(request.resource, "/")
  current_path[1] == "v2"
  current_path[2] == "subscriptions"
}

# Checks if the subscription in the policy matches the path
path_matches_policy(entry, request) {
  entry.resource_type == "subscription"
  current_path := split(request.resource, "/")
  current_path[1] == "v2"
  current_path[2] == "subscriptions"
  current_path[3] == entry.resource
}

# Set the header link for the subscription
header_link = link {
  current_path := split(request.resource, "/")
  current_path[2] == "subscriptions"
  current_path[3]
  not current_path[3] == ""
  link := sprintf("<%s/me?resource=%s&&type=%s>; rel=\"acl\"", [api_uri,current_path[3],"subscription"])
}
header_link = link {
  current_path := split(request.resource, "/")
  current_path[2] == "subscriptions"
  current_path[3] == ""
  link := sprintf("<%s/me?resource=%s&&type=%s>; rel=\"acl\"", [api_uri,"*","subscription"])
}
header_link = link {
  current_path := split(request.resource, "/")
  current_path[2] == "subscriptions"
  not current_path[3]
  link := sprintf("<%s/me?resource=%s&&type=%s>; rel=\"acl\"", [api_uri,"*","subscription"])
}
