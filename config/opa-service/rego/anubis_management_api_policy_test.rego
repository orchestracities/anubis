package envoy.authz

bearer_token = "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJmQlNXZDNYRnBmOHRSb0RQdm1DUnNOcUNYdDA1dzFOajE2TXFMTlctOUNVIn0.eyJleHAiOjE2NjYwMTUwNzgsImlhdCI6MTY2NjAxNTAxOCwianRpIjoiNmU5NTgzMTMtZTVmNi00NWEyLWE3NjUtYmJkYzI0MDk5ZjdiIiwiaXNzIjoiaHR0cDovL2tleWNsb2FrOjgwODAvcmVhbG1zL2RlZmF1bHQiLCJzdWIiOiI1YzY3YjI1MS02ZjYzLTQ2ZjMtYjNiMC0wODVlMWY3MDQwYjIiLCJ0eXAiOiJCZWFyZXIiLCJhenAiOiJjb25maWd1cmF0aW9uIiwic2Vzc2lvbl9zdGF0ZSI6ImVkZjEyNjZhLWI5NTEtNDgyYy04OTIzLTBiYWZlYTQxZDI3NSIsImFjciI6IjEiLCJhbGxvd2VkLW9yaWdpbnMiOlsiKiJdLCJyZXNvdXJjZV9hY2Nlc3MiOnsicmVhbG0tbWFuYWdlbWVudCI6eyJyb2xlcyI6WyJ2aWV3LXJlYWxtIiwibWFuYWdlLXJlYWxtIiwibWFuYWdlLXVzZXJzIiwicXVlcnktcmVhbG1zIiwidmlldy11c2VycyIsInZpZXctY2xpZW50cyIsInF1ZXJ5LWNsaWVudHMiLCJxdWVyeS1ncm91cHMiLCJxdWVyeS11c2VycyJdfX0sInNjb3BlIjoicHJvZmlsZSBlbWFpbCIsInNpZCI6ImVkZjEyNjZhLWI5NTEtNDgyYy04OTIzLTBiYWZlYTQxZDI3NSIsInRlbmFudHMiOnsiVGVuYW50MSI6eyJyb2xlcyI6WyJ0ZW5hbnQtYWRtaW4iXSwiZ3JvdXBzIjpbIi9BZG1pbiIsIi9Hcm91cDEiXSwiaWQiOiJiNjkxZjE1ZC1kNDc1LTRjOWQtOTdmNy1lZThlYzE4YWUyNjIifSwiVGVuYW50MiI6eyJyb2xlcyI6W10sImdyb3VwcyI6WyIvR3JvdXAyIl0sImlkIjoiYTY2NjJlM2YtMDMyOC00M2QxLWI1Y2YtMjVmMzIwOWM1N2U4In19LCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwicHJlZmVycmVkX3VzZXJuYW1lIjoiYWRtaW4iLCJpc19zdXBlcl9hZG1pbiI6dHJ1ZSwiZW1haWwiOiJhZG1pbkBtYWlsLmNvbSJ9.HupAyt646fAi9bV1zZitQW7qVW0SXR1wuCzK7QIYAg-ZkErRsvZlBzSxy5QwGB85iDYa1rEtefRIbgW5MFeJ9e7z15-W0yp_ZFYlAyYT-Sns9JjvcRPuDtqfV0LdDIm9a4OJu0Nh9dDXojVR6PciQwji1RHJ_TL3DKCKLCTaWUReXCmcuej5WYp99InBWcRaSy9d-y1z-e-wsqhFgq5TGyy95t-rVceSieIPHs0G-37ln3NAKo80TPhgeYlbHwiwOqQhnIyqAB5GrGjsXYBx9pLhGQnTV8mb_KInmC98QH7sP0URPzgMP7laj5Yzlgd80fHnUydzFZjv4WQMK65NXg"

policy_data = {
   "user_permissions":{},
   "default_user_permissions":{},
   "group_permissions":{
      "User":[
         {
            "id":"b1b8ade1-03d8-49b1-b3ca-c5428e1a5812",
            "action":"acl:Read",
            "resource":"/v2/entities/some_entity",
            "resource_type":"entity",
            "service_path":"/",
            "tenant":"Tenant1"
         }
      ]
   },
   "default_group_permissions":{},
   "role_permissions":{
      "AuthenticatedAgent":[
         {
            "id":"ee751ca0-03e9-4111-8fe3-827004e2644e",
            "action":"acl:Write",
            "resource":"*",
            "resource_type":"entity",
            "service_path":"/",
            "tenant":"Tenant1"
         },
         {
            "id":"065610db-9e5d-4e97-ba7c-123e0f2d068e",
            "action":"acl:Control",
            "resource":"*",
            "resource_type":"entity",
            "service_path":"/",
            "tenant":"Tenant1"
         },
         {
            "id":"ea2e90d6-7579-4984-8741-0afb158df3c4",
            "action":"acl:Read",
            "resource":"*",
            "resource_type":"policy",
            "service_path":"/",
            "tenant":"Tenant1"
         },
         {
            "id":"900f3357-807d-4ae5-92c0-2a95319d323a",
            "action":"acl:Write",
            "resource":"*",
            "resource_type":"policy",
            "service_path":"/",
            "tenant":"Tenant1"
         },
         {
            "id":"af5f59fd-0951-4ed7-a632-2f21166c077c",
            "action":"acl:Read",
            "resource":"Tenant1",
            "resource_type":"tenant",
            "service_path":"/",
            "tenant":"Tenant1"
         },
         {
            "id":"f984056e-6869-405c-89ec-d7462922c0e8",
            "action":"acl:Write",
            "resource":"Tenant1",
            "resource_type":"tenant",
            "service_path":"/",
            "tenant":"Tenant1"
         },
         {
            "id":"4ff2cde6-a322-42bd-8748-a26c41453bc6",
            "action":"acl:Read",
            "resource":"/",
            "resource_type":"service_path",
            "service_path":"/",
            "tenant":"Tenant1"
         },
         {
            "id":"3fa52257-9e09-48ee-9f2e-80f503ea57d1",
            "action":"acl:Write",
            "resource":"/",
            "resource_type":"service_path",
            "service_path":"/",
            "tenant":"Tenant1"
         }
      ]
   },
   "default_role_permissions":{
      "Admin":[
         {
            "id":"adf46259-ebcd-4b0a-9da4-10b3fc87c53a",
            "action":"acl:Control",
            "resource":"default",
            "resource_type":"policy",
            "service_path":"/",
            "tenant":"Tenant1"
         },
         {
            "id":"c3e99ba5-fe46-4253-9cdd-2f663a9bb03b",
            "action":"acl:Control",
            "resource":"default",
            "resource_type":"entity",
            "service_path":"/",
            "tenant":"Tenant1"
         }
      ],
      "AuthenticatedAgent":[
         {
            "id":"9198afe3-94a4-42fc-bc89-ae252f36b18b",
            "action":"acl:Read",
            "resource":"default",
            "resource_type":"entity",
            "service_path":"/",
            "tenant":"Tenant1"
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
        "action": "acl:Write",
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
        "action": "acl:Write",
        "resource": "/foo/bar",
        "resource_type": "service_path",
        "tenant": "Tenant1",
        "service_path": "/"
      }
    ]
  }
}

test_policy_permissions_all {
  allow.allowed with request as {"user":"admin@mail.com", "action":"POST", "resource":"/v1/policies/", "tenant":"Tenant1", "service_path":"/"} with input.parsed_body as {"access_to":"test","resource_type":"entity"} with data as policy_data with bearer_token as bearer_token with testing as true
}

test_policy_permissions_one {
  allow.allowed with request as {"user":"admin@mail.com", "action":"GET", "resource":"/v1/policies/test", "tenant":"Tenant1", "service_path":"/"} with data as policy_data with bearer_token as bearer_token with testing as true
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
