# Configuration for Turtle serialization

To serialize the policies as RDF graphs using [Turtle (ttl)](https://www.w3.org/TR/turtle/)
format, a configuration file needs to be provided to Anubis.
The configuration file contains the default URI prefixes
for all resource types. The URI can be also configured for each single tenant
as depicted in the [example](https://github.com/orchestracities/anubis/blob/master/config/opa-service/default_wac_config.yml)
below:

```yml
wac:
  default:
      prefix: default
      baseUrl: https://default.url/
      resourceTypeUrls:
        entity:
          url: https://default.orion.url/v2/entities/
          type_url: https://default.url/entity
        entityType:
          url: https://default.orion.url/v2/types/
          type_url: https://default.url/entity_type
        policy:
          url: https://default.anubis.url/v1/policies/
          type_url: https://default.url/policy
  Tenant1:
      prefix: tenant1
      baseUrl: https://tenant1.url/
      resourceTypeUrls:
        entity:
          url: https://tenant1.orion.url/v2/entities/
          type_url: https://tenant1.url/entity
        entityType:
          url: https://tenant1.orion.url/v2/types/
          type_url: https://tenant1.url/entity_type
        policy:
          url: https://tenant1.anubis.url/v1/policies/
          type_url: https://tenant1.url/policy

```
