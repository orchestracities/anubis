
This POC is based on [envoy ext_authz sandbox](https://www.envoyproxy.io/docs/envoy/latest/start/sandboxes/ext_authz).

Scope of the PoC is to test usage of [OPA](https://www.openpolicyagent.org/) to protect NGSIv2 APIs.

At the time being there is a set of [policies](config/opa-service/policy.rego)
that are checked against the JWT token included in the request.

To run the demo:

```bash
$ source .env
$ docker-compose up -d
$ sh token.sh
```

Demo token is an examples OC token (as it is today), and should be restructured
to better allow to check:
- User groups as apart of a tenant (where tenant is still a root group)
- User roles as part of a tenant (or global).

Currently in the demo this information is stored in the policy:

```json
roles = { "631a780d-c7a2-4b6a-acd8-e856348bcb2e" : ["admin", "super_hero"]}
groups = { "631a780d-c7a2-4b6a-acd8-e856348bcb2e" : ["/EKZ/admin", "/EKZ/super_hero"]}
```

The policy also include mappings from resource scope to http method:

```json
scope_method = {"entity:read": "GET", "entity:create": "POST", "entity:delete": "DELETE"}
```

PoC policy are now computed based on the fact that `deny` has priority
over `allow` and by default users are not authorised to access anything.


Single policies in OPA are then stored as follow:

```json
resource_allowed {
    #role based policy
    roles[subject][i] = "admin"
    #is the resource allowed?
    glob.match("/v2/entities", ["/"], path)
    #is the action allowed?
    scope_method["entity:read"] = method
    fiware_service = "EKZ"
    glob.match("/**", ["/"], fiware_servicepath)
}
```

or 

```json
resource_denied {
    "631a780d-c7a2-4b6a-acd8-e856348bcb2e" = subject
    glob.match("/v2/entities/ent2", ["/"], path)
    #is the action allowed?
    scope_method["entity:read"] = method
    fiware_service = "EKZ"
    glob.match("/Path1/Path2", ["/"], fiware_servicepath)
}
```

Basically a policy as we define it, is composed by:
- *Who*: Information on the user: any user / a specific user / a user in a group / a user in a role /
  a combination of previous ones.
- *whom*: Information on the resource, which is composed by:
  - resource identifier: any, entity_id, entity_id and attribute_id, attribute_id
  - resource service: fiware_servicepath
- *what*: the action (scope) that gets translated in to method,
  e.g. entity:read

The example policy covers quite some examples.

What's next? Ideally from here it is possible to design a prototype,
that allows to manage simply these policies in the context of NGSIv2
and NGSI-LD.

- Design an API that allow to record policies for tenant.
  - Ideally based on the above, a policy is a tuple: who / whom / 
    what (eventually in future also when and how)
  - Allow to create and manage "service_paths" for tenants
  - Have way to define who can define policy for which resource
    (it could be based on the same approach)
  - Allows to test policies calling OPA validator
- Design a translator that
  - coverts the abstract policy who / whom / what
  into an OPA policy and records it under a specific context for the given
  tenant. The translator may be different for different API. Policies could be
  stored using a package that define api and tenant so that envoy can
  be configure to load only a specific set of packages. (This has to be
  done understanding how the `path`configuration works. [see](config/opa-service/opa.yaml)).
  Surely the split by api is needed, and that is clearly easy. Having a hierarchy
  with tenant, would simplify the update of the policies from api to OPA, given
  that you would update only a tenant and not the all apis.
  - record data in the OPA data API as needed (may not be required)

