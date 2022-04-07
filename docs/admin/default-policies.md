# Default policies

A set of policies can also be set up to be created upon the creation of
a Tenant through a file.
See this [example](https://github.com/orchestracities/anubis/blob/master/config/opa-service/default_policies.yml).

```yaml
# TODO: This will eventually be a different more fitting wac format
"acl:Authorization":
  - "acl:accessTo":
      value: "default"
      type: "*"
    "acl:agentClass":
      - "acl:AuthenticatedAgent"
    "acl:mode":
      - "acl:Read"
  - "acl:accessTo":
      value: "default"
      type: "*"
    "acl:agentClass":
      - "acl:agentClass:Admin"
    "acl:mode":
```

The path to this file can be set using the
`DEFAULT_POLICIES_CONFIG_FILE` environment variable.

See [Policies](../user/policies.md) for defining them.
