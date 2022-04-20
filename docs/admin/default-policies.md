# Default policies

A set of policies can also be set up to be created upon the creation of
a Tenant through a file, which represents a series of default policies for the
root servicepath `/`. The file is turtle (ttl) format, representing an RDF
graph.

See this [example](https://github.com/orchestracities/anubis/blob/master/config/opa-service/default_policies.yml).

```ttl
@prefix acl: <http://www.w3.org/ns/auth/acl#> .
@prefix tenant: <https://tenant.url/> .

tenant:policy1 a acl:Authorization ;
    acl:agentClass <acl:agentClass:Admin> ;
    acl:default </> ;
    acl:accessToClass <entity> ;
    acl:mode <acl:Control> .

tenant:policy2 a acl:Authorization ;
    acl:agentClass <acl:AuthenticatedAgent> ;
    acl:default </> ;
    acl:accessToClass <entity> ;
    acl:mode <acl:Read> .

tenant:policy3 a acl:Authorization ;
    acl:agentClass <acl:agentClass:Admin> ;
    acl:default </> ;
    acl:accessToClass <policy> ;
    acl:mode <acl:Control> .
```

The path to this file can be set using the
`DEFAULT_POLICIES_CONFIG_FILE` environment variable.

See [Policies](../user/policies.md) for defining them.
