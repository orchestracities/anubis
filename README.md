# OPA-autz

This POC is based on [envoy ext_authz sandbox](https://www.envoyproxy.io/docs/envoy/latest/start/sandboxes/ext_authz).

Scope of the PoC is to test usage of [OPA](https://www.openpolicyagent.org/)
to protect NGSIv2 APIs.

At the time being we have a [rego file](config/opa-service/policy.rego)
that verifies the policies stored in our [policies api](auth-management-api)
specifically for the NGSIv2 Context Broker, as well as checking the JWT token
included in the request.

To run the demo:

```bash
$ source .env
$ docker-compose up -d
$ sh test_rego.sh
```

Demo token is an examples OC token (as it is today).

The policy include mappings from resource scope to http method:

```json
scope_method := {"acl:Read": ["GET"], "acl:Write": ["POST"], "acl:Control": ["PUT", "DELETE"]}
```

PoC by default will not allow any request, unless the user has permissions to
access a given resource, either because of a permission set specifically for it
(user_permissions), belonging to a group that has such permissions (group_permissions)
or having a role that grants such permissions (role_permissions).

A policy for a given tenant is stored in the API as such:

```json
{
"user_permissions": {
    "1c4f9f82-e5a7-4b32-84ea-a1774531f1d2": [
      {
        "action": "acl:Read",
        "resource": "*",
        "resource_type": "entity",
        "tenant": "Tenant",
        "service_path": "/"
      },
      {
        "action": "acl:Write",
        "resource": "foo",
        "resource_type": "entity",
        "tenant": "Tenant",
        "service_path": "/"
      }
    ]
  }
}
```

Where each individual permission is defined by:

* *action*: The action allowed on this resource (e.g. acl:Read for GET requests)
* *resource*: The resource being targetted (e.g. entity_x)
* *resource_type*: The type of the resource (e.g. entity, entity_type,
  subscription, ...)
* *tenant*: The tenant this permission falls under
* *service_path*: The service path this permission falls under

See the test files for more examples as well.

What's next? The API prototype and the Context Broker policy already provide
a good example of this approach with OPA.

* [ ] Design an API that allow to record policies for tenant.
  * [x] Store a policy as a tuple: *who* can access *which* resource to do
    *what* (eventually in future also when and how).
    A prototype is available, see [auth-management-api](auth-management-api).
  * [x] Allow to create and manage "service_paths" for tenants.
    A prototype is available, see [auth-management-api](auth-management-api).
  * [x] Have way to define who can define policy for which resource
    (it could be based on the same approach)
  * [ ] Allows to test policies calling OPA validator
* [ ] Design a translator that
  * [x] coverts the abstract policy who / whom / what
  into an OPA policy and records it under a specific context for the given
  tenant. The translator may be different for different API.
  A prototype is available, see [auth-management-api](auth-management-api),
  translator is only for Orion-like API at the time being.
  * [x] Define a package for api and tenant so that envoy can
   be configured to load only a specific set of packages. (This has to be
   done understanding how the `path` configuration works. [see](config/opa-service/opa.yaml)).
   Surely the split by api is needed, and that is clearly easy. Having a hierarchy
   with tenant, would simplify the update of the policies from api to OPA, given
   that you would update only a tenant and not the all apis. (it seems so looking
   [here](https://github.com/open-policy-agent/opa-envoy-plugin)).
   A prototype is available, see [auth-management-api](auth-management-api),
   the package is only by tenant, since no translation for different API is
   supported.
  * [ ] Store policies in OPA.
  * [ ] Record additional data in the OPA data API as needed
    (may not be required)

To adhere to [W3C web access control spec](https://github.com/solid/web-access-control-spec)
the API management prototype available at [auth-management-api](auth-management-api)
uses acl defined access modes, e.g. `acl:Write`, `acl:Read`, which are different
from the ones in [config/opa-service/policy.rego](config/opa-service/policy.rego)
example (e.g. `entity:read`). Either we align to `acl` standard, or we define
an extension of `acl` with modes needed in our APIs.

The [auth-management-api](auth-management-api) is a prototype, it needs some
work to be more configurable, e.g. in term of db.
