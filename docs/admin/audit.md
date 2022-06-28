# Audit

Anubis API allows to audit the results of policy evaluations for requests
to access resources for the different tenants.

An audit log entry includes:
- the id of the decision
- the type of audit (for the time being only access)
- the service to which the request was directed
- the resource requested
- the resource type of the requested resource
- the access mode requested
- the outcome of the policy evaluation
- the user originating the requested (if a token was used during the request)
- the remote ip used by the client issuing the request
- the timestamp of the request

For example:

    :::json
    {
      "id": "8a86afa0-64a1-42df-9fc0-b539a3abf911",
      "type": "access",
      "service": "context broker",
      "resource": "*",
      "resource_type": "entity",
      "mode": "acl:Read",
      "decision": "True",
      "user": "admin@mail.com",
      "remote_ip": "192.168.80.1",
      "timestamp": "2022-06-28T10:43:41.657657"
    }
