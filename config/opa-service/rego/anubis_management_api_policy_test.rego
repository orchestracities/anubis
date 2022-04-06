package envoy.authz

bearer_token = "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJmQlNXZDNYRnBmOHRSb0RQdm1DUnNOcUNYdDA1dzFOajE2TXFMTlctOUNVIn0.eyJleHAiOjE2NDU2MjgzODgsImlhdCI6MTY0NTYyODMyOCwianRpIjoiNjU2Y2E3MWUtNjA3Mi00MTlhLTk3ZWYtNTVhZDljNWU5Nzk3IiwiaXNzIjoiaHR0cDovL2xvY2FsaG9zdDo4MDgwL2F1dGgvcmVhbG1zL21hc3RlciIsInN1YiI6IjVjNjdiMjUxLTZmNjMtNDZmMy1iM2IwLTA4NWUxZjcwNDBiMiIsInR5cCI6IkJlYXJlciIsImF6cCI6ImNsaWVudDEiLCJzZXNzaW9uX3N0YXRlIjoiZGVmYjc1MzYtYzM4OS00NjA1LWFiOWYtOWNjNzM5YjJiNzFmIiwiYWNyIjoiMSIsInNjb3BlIjoicHJvZmlsZSBlbWFpbCIsInNpZCI6ImRlZmI3NTM2LWMzODktNDYwNS1hYjlmLTljYzczOWIyYjcxZiIsInRlbmFudHMiOlt7Im5hbWUiOiJUZW5hbnQxIiwiZ3JvdXBzIjpbeyJyZWFsbVJvbGVzIjpbXSwibmFtZSI6Ikdyb3VwMSIsImlkIjoiNTczNjkyMDktYWU1Yy00OWMxLWJhYzctODJjMTZjMzAyOWJmIiwiY2xpZW50Um9sZXMiOlsicm9sZTEiXX1dLCJpZCI6ImI2OTFmMTVkLWQ0NzUtNGM5ZC05N2Y3LWVlOGVjMThhZTI2MiJ9LHsibmFtZSI6IlRlbmFudDIiLCJncm91cHMiOlt7InJlYWxtUm9sZXMiOltdLCJuYW1lIjoiR3JvdXAyIiwiaWQiOiI5YjJjMmMzZS1lM2NkLTQ3NTgtOWUxNC1iMDA1ZmVlZjA2ZjEiLCJjbGllbnRSb2xlcyI6WyJyb2xlMiJdfV0sImlkIjoiYTY2NjJlM2YtMDMyOC00M2QxLWI1Y2YtMjVmMzIwOWM1N2U4In1dLCJmaXdhcmUtc2VydmljZXMiOnsiVGVuYW50MSI6WyIvU2VydmljZVBhdGgxIl0sIlRlbmFudDIiOlsiL1NlcnZpY2VQYXRoMiJdfSwiZW1haWxfdmVyaWZpZWQiOnRydWUsInByZWZlcnJlZF91c2VybmFtZSI6ImFkbWluIiwiZW1haWwiOiJhZG1pbkBtYWlsLmNvbSJ9.Vw-nlj2MX4TOKvq5THWGzveqeCf5celP8Ff-RpiBYD_n_xfjUviAZ18EclSniz7jOitKMcLSxFV3EcTeWcRSGuypjHtN5BqW_BKGLyYbUF6p1_kYKJT4Cba_nDb9WW4J6HyyubMJcYwbbsCmtKsP05JWku4lYIu67ZyoejCxHTbofiybX7EPa55gf8EevGTJz77H2x5eplj7pjQoIjPNAb2DnXG_STSAu2iLcwA7JG1VCn_ro_s-PVxLxy2ffAqzyv3O83eJSyMsryqZmIsQAbVuybpfBS3ouHBQXo6aCBz6LgYPZ3c91z0ZtMJZ8ZiKn23jsmNW09FiXuCPfrfUCA"

policy_data = {
"user_permissions": {
    "admin@mail.com": [
      {
        "action": "acl:Read",
        "resource": "*",
        "resource_type": "policy",
        "tenant": "Tenant1",
        "service_path": "/"
      },
      {
        "action": "acl:Control",
        "resource": "test",
        "resource_type": "policy",
        "tenant": "Tenant1",
        "service_path": "/"
      }
    ]
  }
}

tenant_data = {
"user_permissions": {
    "admin@mail.com": [
      {
        "action": "acl:Read",
        "resource": "*",
        "resource_type": "tenant",
        "tenant": "Tenant1",
        "service_path": "/"
      },
      {
        "action": "acl:Control",
        "resource": "Tenant1",
        "resource_type": "tenant",
        "tenant": "Tenant1",
        "service_path": "/"
      }
    ]
  }
}

service_path_data = {
"user_permissions": {
    "admin@mail.com": [
      {
        "action": "acl:Read",
        "resource": "*",
        "resource_type": "service_path",
        "tenant": "Tenant1",
        "service_path": "/"
      },
      {
        "action": "acl:Control",
        "resource": "/foo/bar",
        "resource_type": "service_path",
        "tenant": "Tenant1",
        "service_path": "/"
      }
    ]
  }
}

test_policy_permissions_all {
  allow.allowed with request as {"user":"admin@mail.com", "action":"GET", "resource":"/v1/policies/", "tenant":"Tenant1", "service_path":"/"} with data as policy_data with bearer_token as bearer_token with testing as true
}

test_policy_permissions_one {
  allow.allowed with request as {"user":"admin@mail.com", "action":"PUT", "resource":"/v1/policies/test", "tenant":"Tenant1", "service_path":"/"} with data as policy_data with bearer_token as bearer_token with testing as true
}

test_tenant_permissions_all {
  allow.allowed with request as {"user":"admin@mail.com", "action":"GET", "resource":"/v1/tenants", "tenant":"Tenant1", "service_path":"/"} with data as tenant_data with bearer_token as bearer_token with testing as true
}

test_tenant_permissions_one {
  allow.allowed with request as {"user":"admin@mail.com", "action":"PUT", "resource":"/v1/tenants/Tenant1", "tenant":"Tenant1", "service_path":"/"} with data as tenant_data with bearer_token as bearer_token with testing as true
}

test_service_path_permissions_all {
  allow.allowed with request as {"user":"admin@mail.com", "action":"GET", "resource":"/v1/tenants/Tenant1/service_paths", "tenant":"Tenant1", "service_path":"/"} with data as service_path_data with bearer_token as bearer_token with testing as true
}

test_service_path_permissions_one {
  allow.allowed with request as {"user":"admin@mail.com", "action":"PUT", "resource":"/v1/tenants/Tenant1/service_paths/foo/bar", "tenant":"Tenant1", "service_path":"/"} with data as service_path_data with bearer_token as bearer_token with testing as true
}
