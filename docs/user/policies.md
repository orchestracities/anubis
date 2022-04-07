# Policies

The policy internal data format is inspired by
[Web Access control](https://solid.github.io/web-access-control-spec/).

In general, a policy is defined by:

- *actor*: The user, group or role, that is linked to the policy
- *action*: The action allowed on this resource (e.g. acl:Read for GET requests)
- *resource*: The urn of the resource being targeted (e.g. urn:entity:x)
- *resource_type*: The type of the resource.

For the authorisation rules currently in place, the supported resource types
are:

- *entity*: NGSI entity
- *entity_type*: NGSI entity type
- *subscription*: NGSI subscription
- *policy*: A policy of the Anubis Management API (to allow users to have
  control over the policies that are created)
- *tenant*: A tenant (or Fiware service)
- *service_path*: A Fiware service path under a given tenant.

Additionally, in relation to FIWARE APIs, a policy may include also:

- *tenant*: The tenant this permission falls under
- *service_path*: The service path this permission falls under

## Container default policies

In addition to policies that target specific resources it's possible to create
a "default" type policy that will be applied to any resource in a given tenant
and service path, as well as any subpath of the service path (e.g. a default
policy specifying `/foo` with match `/foo/bar`). Such policy is created by
setting the value of `resource` to `default`.

This maps to the `acl:default` predicate in [WAC](https://solid.github.io/web-access-control-spec/#access-objects)

## Automatically created policies

When creating a new policy from the proxy, a new policy is also automatically
created that gives `acl:Control` rights for the new policy to the user
that created it.
The same happens when creating a new NGSI entity, where an
`acl:Control` policy is created for the new entity, giving control of it to
the user that made the request.

## Policies serialization

Policies can be serialized in different formats.

- application/json:

  ```json
  {
      "access_to": "*",
      "resource_type": "entity",
      "mode": [
          "acl:Write"
      ],
      "agent": [
          "acl:AuthenticatedAgent"
      ],
      "id": "a0be6113-2339-40d7-9e85-56f93372f279"
  }
  ```

- text/rego:

  ```json
  {
    "user_permissions": {},
    "group_permissions": {},
    "role_permissions": {
        "AuthenticatedAgent": [
            {
                "action": "acl:Write",
                "resource": "*",
                "resource_type": "entity",
                "service_path": "/",
                "tenant": "Tenant1"
            }
        ]
    }
  }
  ```

- text/turle:

  ```text
  @prefix acl: <http://www.w3.org/ns/auth/acl#> .
  @prefix example: <http://example.org/> .
  example:a0be6113-2339-40d7-9e85-56f93372f279 a acl:Authorization ;
      acl:accessTo <http://example.org/*> ;
      acl:agentClass <acl:AuthenticatedAgent> ;
      acl:mode <acl:Write> .
  ```

## Access modes and RESTful APIs

To apply the policy to a specific API, we map
[W3C web access control spec](https://github.com/solid/web-access-control-spec)
defined access modes, e.g. `acl:Write`, `acl:Read` to a specific HTTP method,
e.g.:

- `acl:Read`-> GET
- `acl:Write` -> PUT, POST, PATCH, DELETE
- `acl:Append` -> POST, PATCH

While `acl:Control` is used to define who can control the resource,
i.e. define policies for the resource.

In some use cases, the default modes may not be enough,
and you may need to define an extension of `acl` with modes needed in your API.
[Customize](../admin/customize.md) contains guidance on how to create custom
access modes.
