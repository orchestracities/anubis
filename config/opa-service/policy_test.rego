package envoy.authz

bearer_token = "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJmQlNXZDNYRnBmOHRSb0RQdm1DUnNOcUNYdDA1dzFOajE2TXFMTlctOUNVIn0.eyJleHAiOjE2NDQyNDI4NjAsImlhdCI6MTY0NDI0MjgwMCwianRpIjoiMmQ5OWFjZDEtMDdlYi00MDY0LWI4MmQtYjkyZjkwYjIxNWVkIiwiaXNzIjoiaHR0cDovL2xvY2FsaG9zdDo4MDg1L2F1dGgvcmVhbG1zL21hc3RlciIsInN1YiI6IjVjNjdiMjUxLTZmNjMtNDZmMy1iM2IwLTA4NWUxZjcwNDBiMiIsInR5cCI6IkJlYXJlciIsImF6cCI6ImNsaWVudDEiLCJzZXNzaW9uX3N0YXRlIjoiYzNiYmZlZWMtYTlhMy00MzE1LWJhMGEtMDk0YzZiOTVmNWU5IiwiYWNyIjoiMSIsInNjb3BlIjoicHJvZmlsZSBlbWFpbCIsInNpZCI6ImMzYmJmZWVjLWE5YTMtNDMxNS1iYTBhLTA5NGM2Yjk1ZjVlOSIsInRlbmFudHMiOlt7Im5hbWUiOiJUZW5hbnQxIiwiZ3JvdXBzIjpbeyJyZWFsbVJvbGVzIjpbXSwibmFtZSI6Ikdyb3VwMSIsImlkIjoiNTczNjkyMDktYWU1Yy00OWMxLWJhYzctODJjMTZjMzAyOWJmIiwiY2xpZW50Um9sZXMiOlsicm9sZTEiXX1dLCJpZCI6ImI2OTFmMTVkLWQ0NzUtNGM5ZC05N2Y3LWVlOGVjMThhZTI2MiJ9LHsibmFtZSI6IlRlbmFudDIiLCJncm91cHMiOlt7InJlYWxtUm9sZXMiOltdLCJuYW1lIjoiR3JvdXAyIiwiaWQiOiI5YjJjMmMzZS1lM2NkLTQ3NTgtOWUxNC1iMDA1ZmVlZjA2ZjEiLCJjbGllbnRSb2xlcyI6WyJyb2xlMiJdfV0sImlkIjoiYTY2NjJlM2YtMDMyOC00M2QxLWI1Y2YtMjVmMzIwOWM1N2U4In1dLCJmaXdhcmUtc2VydmljZXMiOnsiVGVuYW50MSI6WyIvU2VydmljZVBhdGgxIl0sIlRlbmFudDIiOlsiL1NlcnZpY2VQYXRoMiJdfSwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiJhZG1pbiJ9.cjWn-Up3wmtDuZjkTx_OpFOZUjCzmDvu77tXVHwmSQDbWhUrMoTU7U7eZMHDlaQaUq6RhCfNkDI2wcpHZurkDGnaLp9E99dVv8kLrpU5akdItHlmnEP2spC2c49ZyilaD4i86PKb9rn8ccDTNN3bODZCy9zwgMUPKr90fOSChsHqC_dWk1Rd4_7LI2FQINiMRN_f4_GByUMdr48mY7l4vffMxzXJcBbAX0n4-lX9vBj1FrvJUyt5FLir9_khEY5oMCt9O9J-6ARAWpc7qqm7twoBMN0jZltfluq8_5D0K0Dwiu-EC23DVZV6pMMhPJt4copIJsMmMj6MPAYyQWiMcg"

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
#   authz with request as {"user":"5c67b251-6f63-46f3-b3b0-085e1f7040b2", "action":"GET", "resource":"/v2/entities/test", "tenant":"Tenant1", "service_path":"/"} with bearer_token as bearer_token with api_uri as "http://policy-api:8080/v1/policies/"
# }
