# Turtle serialization

For serializing the policies as RDF graphs in Turtle (ttl) format a
configuration file is provided to Anubis that contains the URI prefixes, per
tenant name and a default, for all resource types supported.

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

See this [example](https://github.com/orchestracities/anubis/blob/master/config/opa-service/default_wac_config.yml).
