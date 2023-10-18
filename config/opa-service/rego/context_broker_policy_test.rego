package envoy.authz

bearer_token = "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJmQlNXZDNYRnBmOHRSb0RQdm1DUnNOcUNYdDA1dzFOajE2TXFMTlctOUNVIn0.eyJleHAiOjE2NjYwMTUwNzgsImlhdCI6MTY2NjAxNTAxOCwianRpIjoiNmU5NTgzMTMtZTVmNi00NWEyLWE3NjUtYmJkYzI0MDk5ZjdiIiwiaXNzIjoiaHR0cDovL2tleWNsb2FrOjgwODAvcmVhbG1zL2RlZmF1bHQiLCJzdWIiOiI1YzY3YjI1MS02ZjYzLTQ2ZjMtYjNiMC0wODVlMWY3MDQwYjIiLCJ0eXAiOiJCZWFyZXIiLCJhenAiOiJjb25maWd1cmF0aW9uIiwic2Vzc2lvbl9zdGF0ZSI6ImVkZjEyNjZhLWI5NTEtNDgyYy04OTIzLTBiYWZlYTQxZDI3NSIsImFjciI6IjEiLCJhbGxvd2VkLW9yaWdpbnMiOlsiKiJdLCJyZXNvdXJjZV9hY2Nlc3MiOnsicmVhbG0tbWFuYWdlbWVudCI6eyJyb2xlcyI6WyJ2aWV3LXJlYWxtIiwibWFuYWdlLXJlYWxtIiwibWFuYWdlLXVzZXJzIiwicXVlcnktcmVhbG1zIiwidmlldy11c2VycyIsInZpZXctY2xpZW50cyIsInF1ZXJ5LWNsaWVudHMiLCJxdWVyeS1ncm91cHMiLCJxdWVyeS11c2VycyJdfX0sInNjb3BlIjoicHJvZmlsZSBlbWFpbCIsInNpZCI6ImVkZjEyNjZhLWI5NTEtNDgyYy04OTIzLTBiYWZlYTQxZDI3NSIsInRlbmFudHMiOnsiVGVuYW50MSI6eyJyb2xlcyI6WyJ0ZW5hbnQtYWRtaW4iXSwiZ3JvdXBzIjpbIi9BZG1pbiIsIi9Hcm91cDEiXSwiaWQiOiJiNjkxZjE1ZC1kNDc1LTRjOWQtOTdmNy1lZThlYzE4YWUyNjIifSwiVGVuYW50MiI6eyJyb2xlcyI6W10sImdyb3VwcyI6WyIvR3JvdXAyIl0sImlkIjoiYTY2NjJlM2YtMDMyOC00M2QxLWI1Y2YtMjVmMzIwOWM1N2U4In19LCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwicHJlZmVycmVkX3VzZXJuYW1lIjoiYWRtaW4iLCJpc19zdXBlcl9hZG1pbiI6dHJ1ZSwiZW1haWwiOiJhZG1pbkBtYWlsLmNvbSJ9.HupAyt646fAi9bV1zZitQW7qVW0SXR1wuCzK7QIYAg-ZkErRsvZlBzSxy5QwGB85iDYa1rEtefRIbgW5MFeJ9e7z15-W0yp_ZFYlAyYT-Sns9JjvcRPuDtqfV0LdDIm9a4OJu0Nh9dDXojVR6PciQwji1RHJ_TL3DKCKLCTaWUReXCmcuej5WYp99InBWcRaSy9d-y1z-e-wsqhFgq5TGyy95t-rVceSieIPHs0G-37ln3NAKo80TPhgeYlbHwiwOqQhnIyqAB5GrGjsXYBx9pLhGQnTV8mb_KInmC98QH7sP0URPzgMP7laj5Yzlgd80fHnUydzFZjv4WQMK65NXg"

user_data = {
"user_permissions": {
    "admin@mail.com": [
      {
        "action": "acl:Read",
        "resource": "*",
        "resource_type": "entity",
        "tenant": "Tenant1",
        "service_path": "/"
      },
      {
        "action": "acl:Write",
        "resource": "*",
        "resource_type": "entity_type",
        "tenant": "Tenant1",
        "service_path": "/"
      }
    ]
  }
}

user_data_constraint = {
"user_permissions": {
    "admin@mail.com": [
      {
        "action": "acl:Read",
        "resource": "test",
        "resource_type": "entity",
        "tenant": "Tenant1",
        "service_path": "/",
        "constraint": "acl-oc:ResourceName acl:operator:hasPart test"
      },
      {
        "action": "acl:Read",
        "resource": "foo",
        "resource_type": "entity",
        "tenant": "Tenant1",
        "service_path": "/",
        "constraint": "acl-oc:ResourceName acl:operator:eq foo"
      },
      {
        "action": "acl:Read",
        "resource": "6",
        "resource_type": "entity",
        "tenant": "Tenant1",
        "service_path": "/",
        "constraint": "acl-oc:ResourceName acl:operator:gt 5"
      }
    ]
  }
}

group_data = {
"group_permissions": {
    "/Group1": [
      {
        "action": "acl:Write",
        "resource": "test",
        "resource_type": "entity",
        "tenant": "Tenant1",
        "service_path": "/"
      }
    ]
  }
}

role_data = {
"role_permissions": {
    "tenant-admin": [
      {
        "action": "acl:Read",
        "resource": "test",
        "resource_type": "entity",
        "tenant": "Tenant1",
        "service_path": "/"
      }
    ]
  }
}

authenticated_agent_data = {
"role_permissions": {
    "AuthenticatedAgent": [
      {
        "action": "acl:Read",
        "resource": "*",
        "resource_type": "entity",
        "tenant": "Tenant1",
        "service_path": "/"
      }
    ]
  }
}

foaf_agent_data = {
"role_permissions": {
    "Agent": [
      {
        "action": "acl:Read",
        "resource": "*",
        "resource_type": "entity",
        "tenant": "Tenant1",
        "service_path": "/"
      }
    ]
  }
}

default_data = {
"default_role_permissions": {
    "AuthenticatedAgent": [
      {
        "action": "acl:Read",
        "resource": "default",
        "resource_type": "entity",
        "tenant": "Tenant1",
        "service_path": "/test"
      }
    ]
  }
}

test_user_permissions {
  check_policy with request as {"user":"admin@mail.com", "action":"GET", "resource":"/v2/entities/test", "tenant":"Tenant1", "service_path":"/"} with policies as user_data with bearer_token as bearer_token with testing as true
}

test_user_permissions_contraint_1 {
  check_policy with request as {"user":"admin@mail.com", "action":"GET", "resource":"/v2/entities/test", "tenant":"Tenant1", "service_path":"/"} with policies as user_data_constraint with bearer_token as bearer_token with testing as true
}

test_user_permissions_contraint_2 {
  check_policy with request as {"user":"admin@mail.com", "action":"GET", "resource":"/v2/entities/foo", "tenant":"Tenant1", "service_path":"/"} with policies as user_data_constraint with bearer_token as bearer_token with testing as true
}

test_user_permissions_contraint_3 {
  not check_policy with request as {"user":"admin@mail.com", "action":"GET", "resource":"/v2/entities/foobar", "tenant":"Tenant1", "service_path":"/"} with policies as user_data_constraint with bearer_token as bearer_token with testing as true
}

test_user_permissions_contraint_4 {
  check_policy with request as {"user":"admin@mail.com", "action":"GET", "resource":"/v2/entities/6", "tenant":"Tenant1", "service_path":"/"} with policies as user_data_constraint with bearer_token as bearer_token with testing as true
}

test_user_permissions_contraint_4 {
  not check_policy with request as {"user":"admin@mail.com", "action":"GET", "resource":"/v2/entities/5", "tenant":"Tenant1", "service_path":"/"} with policies as user_data_constraint with bearer_token as bearer_token with testing as true
}

test_user_permissions_unathorized {
  not check_policy with request as {"user":"admin@mail.com", "action":"PATCH", "resource":"/v2/entities/test", "tenant":"Tenant1", "service_path":"/"} with policies as user_data with bearer_token as bearer_token with testing as true
}

test_user_permissions_entity_type {
  check_policy with request as {"user":"admin@mail.com", "action":"POST", "resource":"/v2/types/test", "tenant":"Tenant1", "service_path":"/"} with policies as user_data with bearer_token as bearer_token with testing as true
}

test_group_permissions {
  check_policy with request as {"user":"admin@mail.com", "action":"POST", "resource":"/v2/entities/test", "tenant":"Tenant1", "service_path":"/"} with policies as group_data with bearer_token as bearer_token with testing as true
}

test_group_permissions_unathorized {
  not check_policy with request as {"user":"admin@mail.com", "action":"PATCH", "resource":"/v2/entities/test2", "tenant":"Tenant1", "service_path":"/"} with policies as group_data with bearer_token as bearer_token with testing as true
}

test_role_permissions {
  check_policy with request as {"user":"admin@mail.com", "action":"GET", "resource":"/v2/entities/test", "tenant":"Tenant1", "service_path":"/"} with policies as role_data with bearer_token as bearer_token with testing as true
}

test_role_permissions_unathorized {
  not check_policy with request as {"user":"admin@mail.com", "action":"PATCH", "resource":"/v2/entities/test2", "tenant":"Tenant1", "service_path":"/"} with policies as role_data with bearer_token as bearer_token with testing as true
}

test_authenticated_agent_permissions {
  check_policy with request as {"user":"admin@mail.com", "action":"GET", "resource":"/v2/entities/test", "tenant":"Tenant1", "service_path":"/"} with policies as authenticated_agent_data with bearer_token as bearer_token with testing as true
}

test_foaf_agent_permissions {
  check_policy with request as {"user":"admin@mail.com", "action":"GET", "resource":"/v2/entities/test", "tenant":"Tenant1", "service_path":"/"} with policies as foaf_agent_data with testing as true
}

test_default_agent_permissions {
  check_policy with request as {"user":"foobar", "action":"GET", "resource":"/v2/entities/test", "tenant":"Tenant1", "service_path":"/test/foobar"} with policies as default_data with testing as true
}

# test_api {
#   allow.allowed with request as {"user":"admin@mail.com", "action":"GET", "resource":"/v2/entities/test", "tenant":"Tenant1", "service_path":"/"} with bearer_token as bearer_token with api_uri as "http://policy-api:8085/v1/policies/" with valid_iss as ["http://keycloak:8080/auth/realms/master"]
# }
