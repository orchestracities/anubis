package envoy.authz

bearer_token = "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJmQlNXZDNYRnBmOHRSb0RQdm1DUnNOcUNYdDA1dzFOajE2TXFMTlctOUNVIn0.eyJleHAiOjE2NDUxOTcyMDAsImlhdCI6MTY0NTE5NzE0MCwianRpIjoiNmJmOTAwMDUtNWIzMi00MzRiLTk3M2ItN2YwZDQ5ZGU5MTFmIiwiaXNzIjoiaHR0cDovL2tleWNsb2FrOjgwODAvYXV0aC9yZWFsbXMvbWFzdGVyIiwic3ViIjoiNWM2N2IyNTEtNmY2My00NmYzLWIzYjAtMDg1ZTFmNzA0MGIyIiwidHlwIjoiQmVhcmVyIiwiYXpwIjoiY2xpZW50MSIsInNlc3Npb25fc3RhdGUiOiI0YTBiYmRhNi00YTExLTQzMmMtOGFjYi03YTBlMDI1NjRmZWIiLCJhY3IiOiIxIiwic2NvcGUiOiJwcm9maWxlIGVtYWlsIiwic2lkIjoiNGEwYmJkYTYtNGExMS00MzJjLThhY2ItN2EwZTAyNTY0ZmViIiwidGVuYW50cyI6W3sibmFtZSI6IlRlbmFudDEiLCJncm91cHMiOlt7InJlYWxtUm9sZXMiOltdLCJuYW1lIjoiR3JvdXAxIiwiaWQiOiI1NzM2OTIwOS1hZTVjLTQ5YzEtYmFjNy04MmMxNmMzMDI5YmYiLCJjbGllbnRSb2xlcyI6WyJyb2xlMSJdfV0sImlkIjoiYjY5MWYxNWQtZDQ3NS00YzlkLTk3ZjctZWU4ZWMxOGFlMjYyIn0seyJuYW1lIjoiVGVuYW50MiIsImdyb3VwcyI6W3sicmVhbG1Sb2xlcyI6W10sIm5hbWUiOiJHcm91cDIiLCJpZCI6IjliMmMyYzNlLWUzY2QtNDc1OC05ZTE0LWIwMDVmZWVmMDZmMSIsImNsaWVudFJvbGVzIjpbInJvbGUyIl19XSwiaWQiOiJhNjY2MmUzZi0wMzI4LTQzZDEtYjVjZi0yNWYzMjA5YzU3ZTgifV0sImZpd2FyZS1zZXJ2aWNlcyI6eyJUZW5hbnQxIjpbIi9TZXJ2aWNlUGF0aDEiXSwiVGVuYW50MiI6WyIvU2VydmljZVBhdGgyIl19LCJlbWFpbF92ZXJpZmllZCI6ZmFsc2UsInByZWZlcnJlZF91c2VybmFtZSI6ImFkbWluIn0.kayjqkz_yK0SJ9lZsm9haPGQmPBn66Ez4wA0S76IMBFWvKs54I33tlFaJK6PZ5y7RxTAm8Y0xnkUU2NgqrRIPgaJHtQWTfhil9daM9Yl75JU51Ck4Z1Pc2zd5zHNwarBrH4XudXP17AY6pS8CSANMhlvdatwM7ZvqepzOKIWeIHWM60vexOUIonltEfH4WJ5VmYNB1xnggJRMDVvbcpsW-6phxo-yx1sjKwdFrjdNFaxsF2Qid5at51fbfiooNZzypej2Ef9lQ2NR98C_t2F0dvyi-60Qq994HvyUilWpij9AzxrLLkX3ehMaD4Ofsz6WhzLZtLHJ0UaIoPbHzPfJw"

user_data = {
"user_permissions": {
    "5c67b251-6f63-46f3-b3b0-085e1f7040b2": [
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

test_user_permissions {
  authz with request as {"user":"5c67b251-6f63-46f3-b3b0-085e1f7040b2", "action":"GET", "resource":"/v2/entities/test", "tenant":"Tenant1", "service_path":"/"} with data as user_data with bearer_token as bearer_token with testing as true
}

test_user_permissions_unathorized {
  not authz with request as {"user":"5c67b251-6f63-46f3-b3b0-085e1f7040b2", "action":"POST", "resource":"/v2/entities/test", "tenant":"Tenant1", "service_path":"/"} with data as user_data with bearer_token as bearer_token with testing as true
}

test_user_permissions_entity_type {
  authz with request as {"user":"5c67b251-6f63-46f3-b3b0-085e1f7040b2", "action":"POST", "resource":"/v2/types/test", "tenant":"Tenant1", "service_path":"/"} with data as user_data with bearer_token as bearer_token with testing as true
}

test_group_permissions {
  authz with request as {"user":"5c67b251-6f63-46f3-b3b0-085e1f7040b2", "action":"POST", "resource":"/v2/entities/test", "tenant":"Tenant1", "service_path":"/"} with data as group_data with bearer_token as bearer_token with testing as true
}

test_group_permissions_unathorized {
  not authz with request as {"user":"5c67b251-6f63-46f3-b3b0-085e1f7040b2", "action":"PUT", "resource":"/v2/entities/test", "tenant":"Tenant1", "service_path":"/"} with data as group_data with bearer_token as bearer_token with testing as true
}

test_role_permissions {
  authz with request as {"user":"5c67b251-6f63-46f3-b3b0-085e1f7040b2", "action":"PUT", "resource":"/v2/entities/test", "tenant":"Tenant1", "service_path":"/"} with data as role_data with bearer_token as bearer_token with testing as true
}

test_role_permissions_unathorized {
  not authz with request as {"user":"5c67b251-6f63-46f3-b3b0-085e1f7040b2", "action":"POST", "resource":"/v2/entities/test", "tenant":"Tenant1", "service_path":"/"} with data as role_data with bearer_token as bearer_token with testing as true
}

test_authenticated_agent_permissions {
  authz with request as {"user":"5c67b251-6f63-46f3-b3b0-085e1f7040b2", "action":"GET", "resource":"/v2/entities/test", "tenant":"Tenant1", "service_path":"/"} with data as authenticated_agent_data with bearer_token as bearer_token with testing as true
}

test_foaf_agent_permissions {
  authz with request as {"user":"5c67b251-6f63-46f3-b3b0-085e1f7040b2", "action":"GET", "resource":"/v2/entities/test", "tenant":"Tenant1", "service_path":"/"} with data as foaf_agent_data with testing as true
}

# test_api {
#   authz with request as {"user":"5c67b251-6f63-46f3-b3b0-085e1f7040b2", "action":"GET", "resource":"/v2/entities/test", "tenant":"Tenant1", "service_path":"/"} with bearer_token as bearer_token with api_uri as "http://policy-api:8085/v1/policies/" with valid_iss as ["http://keycloak:8080/auth/realms/master"]
# }
