package envoy.authz

bearer_token = "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJmQlNXZDNYRnBmOHRSb0RQdm1DUnNOcUNYdDA1dzFOajE2TXFMTlctOUNVIn0.eyJleHAiOjE2NDU2MjgzODgsImlhdCI6MTY0NTYyODMyOCwianRpIjoiNjU2Y2E3MWUtNjA3Mi00MTlhLTk3ZWYtNTVhZDljNWU5Nzk3IiwiaXNzIjoiaHR0cDovL2xvY2FsaG9zdDo4MDgwL2F1dGgvcmVhbG1zL21hc3RlciIsInN1YiI6IjVjNjdiMjUxLTZmNjMtNDZmMy1iM2IwLTA4NWUxZjcwNDBiMiIsInR5cCI6IkJlYXJlciIsImF6cCI6ImNsaWVudDEiLCJzZXNzaW9uX3N0YXRlIjoiZGVmYjc1MzYtYzM4OS00NjA1LWFiOWYtOWNjNzM5YjJiNzFmIiwiYWNyIjoiMSIsInNjb3BlIjoicHJvZmlsZSBlbWFpbCIsInNpZCI6ImRlZmI3NTM2LWMzODktNDYwNS1hYjlmLTljYzczOWIyYjcxZiIsInRlbmFudHMiOlt7Im5hbWUiOiJUZW5hbnQxIiwiZ3JvdXBzIjpbeyJyZWFsbVJvbGVzIjpbXSwibmFtZSI6Ikdyb3VwMSIsImlkIjoiNTczNjkyMDktYWU1Yy00OWMxLWJhYzctODJjMTZjMzAyOWJmIiwiY2xpZW50Um9sZXMiOlsicm9sZTEiXX1dLCJpZCI6ImI2OTFmMTVkLWQ0NzUtNGM5ZC05N2Y3LWVlOGVjMThhZTI2MiJ9LHsibmFtZSI6IlRlbmFudDIiLCJncm91cHMiOlt7InJlYWxtUm9sZXMiOltdLCJuYW1lIjoiR3JvdXAyIiwiaWQiOiI5YjJjMmMzZS1lM2NkLTQ3NTgtOWUxNC1iMDA1ZmVlZjA2ZjEiLCJjbGllbnRSb2xlcyI6WyJyb2xlMiJdfV0sImlkIjoiYTY2NjJlM2YtMDMyOC00M2QxLWI1Y2YtMjVmMzIwOWM1N2U4In1dLCJmaXdhcmUtc2VydmljZXMiOnsiVGVuYW50MSI6WyIvU2VydmljZVBhdGgxIl0sIlRlbmFudDIiOlsiL1NlcnZpY2VQYXRoMiJdfSwiZW1haWxfdmVyaWZpZWQiOnRydWUsInByZWZlcnJlZF91c2VybmFtZSI6ImFkbWluIiwiZW1haWwiOiJhZG1pbkBtYWlsLmNvbSJ9.Vw-nlj2MX4TOKvq5THWGzveqeCf5celP8Ff-RpiBYD_n_xfjUviAZ18EclSniz7jOitKMcLSxFV3EcTeWcRSGuypjHtN5BqW_BKGLyYbUF6p1_kYKJT4Cba_nDb9WW4J6HyyubMJcYwbbsCmtKsP05JWku4lYIu67ZyoejCxHTbofiybX7EPa55gf8EevGTJz77H2x5eplj7pjQoIjPNAb2DnXG_STSAu2iLcwA7JG1VCn_ro_s-PVxLxy2ffAqzyv3O83eJSyMsryqZmIsQAbVuybpfBS3ouHBQXo6aCBz6LgYPZ3c91z0ZtMJZ8ZiKn23jsmNW09FiXuCPfrfUCA"

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

group_data = {
"group_permissions": {
    "Group1": [
      {
        "action": "acl:Write",
        "resource": "*",
        "resource_type": "entity",
        "tenant": "Tenant1",
        "service_path": "/"
      }
    ]
  }
}

role_data = {
"role_permissions": {
    "role1": [
      {
        "action": "acl:Control",
        "resource": "*",
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
        "resource_type": "*",
        "tenant": "Tenant1",
        "service_path": "/test"
      }
    ]
  }
}

test_user_permissions {
  allow.allowed with request as {"user":"admin@mail.com", "action":"GET", "resource":"/v2/entities/test", "tenant":"Tenant1", "service_path":"/"} with data as user_data with bearer_token as bearer_token with testing as true
}

test_user_permissions_unathorized {
  not allow.allowed with request as {"user":"admin@mail.com", "action":"POST", "resource":"/v2/entities/test", "tenant":"Tenant1", "service_path":"/"} with data as user_data with bearer_token as bearer_token with testing as true
}

test_user_permissions_entity_type {
  allow.allowed with request as {"user":"admin@mail.com", "action":"POST", "resource":"/v2/types/test", "tenant":"Tenant1", "service_path":"/"} with data as user_data with bearer_token as bearer_token with testing as true
}

test_group_permissions {
  allow.allowed with request as {"user":"admin@mail.com", "action":"POST", "resource":"/v2/entities/test", "tenant":"Tenant1", "service_path":"/"} with data as group_data with bearer_token as bearer_token with testing as true
}

test_group_permissions_unathorized {
  not allow.allowed with request as {"user":"admin@mail.com", "action":"PUT", "resource":"/v2/entities/test", "tenant":"Tenant1", "service_path":"/"} with data as group_data with bearer_token as bearer_token with testing as true
}

test_role_permissions {
  allow.allowed with request as {"user":"admin@mail.com", "action":"PUT", "resource":"/v2/entities/test", "tenant":"Tenant1", "service_path":"/"} with data as role_data with bearer_token as bearer_token with testing as true
}

test_role_permissions_unathorized {
  not allow.allowed with request as {"user":"admin@mail.com", "action":"POST", "resource":"/v2/entities/test", "tenant":"Tenant1", "service_path":"/"} with data as role_data with bearer_token as bearer_token with testing as true
}

test_authenticated_agent_permissions {
  allow.allowed with request as {"user":"admin@mail.com", "action":"GET", "resource":"/v2/entities/test", "tenant":"Tenant1", "service_path":"/"} with data as authenticated_agent_data with bearer_token as bearer_token with testing as true
}

test_foaf_agent_permissions {
  allow.allowed with request as {"user":"admin@mail.com", "action":"GET", "resource":"/v2/entities/test", "tenant":"Tenant1", "service_path":"/"} with data as foaf_agent_data with testing as true
}

test_default_agent_permissions {
  allow.allowed with request as {"user":"foobar", "action":"GET", "resource":"/v2/entities/test", "tenant":"Tenant1", "service_path":"/test/foobar"} with data as default_data with testing as true
}

# test_api {
#   allow.allowed with request as {"user":"admin@mail.com", "action":"GET", "resource":"/v2/entities/test", "tenant":"Tenant1", "service_path":"/"} with bearer_token as bearer_token with api_uri as "http://policy-api:8085/v1/policies/" with valid_iss as ["http://keycloak:8080/auth/realms/master"]
# }
