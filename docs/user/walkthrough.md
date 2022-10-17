<!-- markdownlint-disable -->
# Anubis
Anubis is a flexible Policy Enforcement solution that makes easier to reuse security policies across different services, assuming the policies entail the same resource.

## Version: 0.5.0-dev

### /v1/tenants/service_paths

#### GET
##### Summary:

List all Service Paths

##### Parameters

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |
| skip | query |  | No | integer |
| limit | query |  | No | integer |

##### Responses

| Code | Description |
| ---- | ----------- |
| 200 | Successful Response |
| 404 | Not found |
| 422 | Validation Error |

### /v1/tenants/

#### GET
##### Summary:

List all Tenants

##### Parameters

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |
| skip | query |  | No | integer |
| limit | query |  | No | integer |

##### Responses

| Code | Description |
| ---- | ----------- |
| 200 | Successful Response |
| 404 | Not found |
| 422 | Validation Error |

#### POST
##### Summary:

Create a new Tenant

##### Responses

| Code | Description |
| ---- | ----------- |
| 201 | Successful Response |
| 404 | Not found |
| 422 | Validation Error |

##### Security

| Security Schema | Scopes |
| --- | --- |
| OptionalHTTPBearer | |

### /v1/tenants/{tenant_id}

#### GET
##### Summary:

Get a Tenant

##### Parameters

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |
| tenant_id | path |  | Yes | string |

##### Responses

| Code | Description |
| ---- | ----------- |
| 200 | Successful Response |
| 404 | Not found |
| 422 | Validation Error |

#### DELETE
##### Summary:

Delete a Tenant

##### Parameters

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |
| tenant_id | path |  | Yes | string |

##### Responses

| Code | Description |
| ---- | ----------- |
| 204 | Successful Response |
| 404 | Not found |
| 422 | Validation Error |

### /v1/tenants/{tenant_id}/service_paths

#### GET
##### Summary:

List Service Paths inside a Tenant

##### Parameters

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |
| tenant_id | path |  | Yes | string |
| name | query |  | No | string |
| skip | query |  | No | integer |
| limit | query |  | No | integer |

##### Responses

| Code | Description |
| ---- | ----------- |
| 200 | Successful Response |
| 404 | Not found |
| 422 | Validation Error |

#### POST
##### Summary:

Create a new Service Path inside a Tenant

##### Parameters

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |
| tenant_id | path |  | Yes | string |

##### Responses

| Code | Description |
| ---- | ----------- |
| 201 | Successful Response |
| 404 | Not found |
| 422 | Validation Error |

### /v1/tenants/{tenant_id}/service_paths/{service_path_id}

#### GET
##### Summary:

Get a Service Path inside a Tenant

##### Parameters

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |
| tenant_id | path |  | Yes | string |
| service_path_id | path |  | Yes | string |

##### Responses

| Code | Description |
| ---- | ----------- |
| 200 | Successful Response |
| 404 | Not found |
| 422 | Validation Error |

#### DELETE
##### Summary:

Delete a Service Path inside a Tenant

##### Parameters

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |
| tenant_id | path |  | Yes | string |
| service_path_id | path |  | Yes | string |

##### Responses

| Code | Description |
| ---- | ----------- |
| 204 | Successful Response |
| 404 | Not found |
| 422 | Validation Error |

### /v1/policies/access-modes

#### GET
##### Summary:

List supported Access Modes

##### Parameters

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |
| skip | query |  | No | integer |
| limit | query |  | No | integer |

##### Responses

| Code | Description |
| ---- | ----------- |
| 200 | Successful Response |
| 404 | Not found |
| 422 | Validation Error |

### /v1/policies/agent-types

#### GET
##### Summary:

List supported Agent Types

##### Parameters

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |
| skip | query |  | No | integer |
| limit | query |  | No | integer |

##### Responses

| Code | Description |
| ---- | ----------- |
| 200 | Successful Response |
| 404 | Not found |
| 422 | Validation Error |

### /v1/policies/

#### GET
##### Summary:

List policies for a given Tenant and Service Path

##### Description:

Policies can be filtered by:
  - Access Mode
  - Agent
  - Agent Type
  - Resource
  - Resource Type
In case an JWT token is passed over, user id, roles and groups are used to
filter policies that are only valid for him.
To return policies from a service path tree, you can used the wildchar "#".
For example, using `/Path1/#` you will obtain policies for all subpaths,
such as: `/Path1/SubPath1` or `/Path1/SubPath1/SubSubPath1`.

##### Parameters

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |
| mode | query |  | No | string |
| agent | query |  | No | string |
| resource | query |  | No | string |
| resource_type | query |  | No | string |
| agent_type | query |  | No | string |
| skip | query |  | No | integer |
| limit | query |  | No | integer |
| fiware-service | header |  | No | string |
| fiware-servicepath | header |  | No | string |
| accept | header |  | No | string |

##### Responses

| Code | Description |
| ---- | ----------- |
| 200 | Success |
| 404 | Not found |
| 422 | Validation Error |

##### Security

| Security Schema | Scopes |
| --- | --- |
| OptionalHTTPBearer | |

#### POST
##### Summary:

Create a policy for a given Tenant and Service Path

##### Parameters

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |
| fiware-service | header |  | No | string |
| fiware-servicepath | header |  | No | string |

##### Responses

| Code | Description |
| ---- | ----------- |
| 201 | Successful Response |
| 404 | Not found |
| 422 | Validation Error |

### /v1/policies/{policy_id}

#### GET
##### Summary:

Get a policy

##### Parameters

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |
| policy_id | path |  | Yes | string |
| skip | query |  | No | integer |
| limit | query |  | No | integer |
| fiware-service | header |  | No | string |
| fiware-servicepath | header |  | No | string |
| accept | header |  | No | string |

##### Responses

| Code | Description |
| ---- | ----------- |
| 200 | Success |
| 404 | Not found |
| 422 | Validation Error |

#### PUT
##### Summary:

Update a policy for a given Tenant and Service Path

##### Parameters

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |
| policy_id | path |  | Yes | string |
| fiware-service | header |  | No | string |
| fiware-servicepath | header |  | No | string |

##### Responses

| Code | Description |
| ---- | ----------- |
| 204 | Successful Response |
| 404 | Not found |
| 422 | Validation Error |

#### DELETE
##### Summary:

Delete a policy for a given Tenant and Service Path

##### Parameters

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |
| policy_id | path |  | Yes | string |
| fiware-service | header |  | No | string |
| fiware-servicepath | header |  | No | string |

##### Responses

| Code | Description |
| ---- | ----------- |
| 204 | Successful Response |
| 404 | Not found |
| 422 | Validation Error |

### /v1/audit/logs

#### GET
##### Summary:

List all Audit Logs

##### Description:

TODO:
Logs can be filtered by:
In case an JWT token is passed over ...

##### Parameters

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |
| user | query |  | No | string |
| resource | query |  | No | string |
| resource_type | query |  | No | string |
| mode | query |  | No | string |
| decision | query |  | No | string |
| type | query |  | No | string |
| service | query |  | No | string |
| fromDate | query |  | No | dateTime |
| toDate | query |  | No | dateTime |
| skip | query |  | No | integer |
| limit | query |  | No | integer |
| authorization | header |  | No | string |
| fiware-service | header |  | No | string |
| fiware-servicepath | header |  | No | string |

##### Responses

| Code | Description |
| ---- | ----------- |
| 200 | Successful Response |
| 404 | Not found |
| 422 | Validation Error |

#### POST
##### Summary:

Create Audit Logs

##### Responses

| Code | Description |
| ---- | ----------- |
| 200 | Successful Response |
| 404 | Not found |
| 422 | Validation Error |

### /v1/audit/logs/{audit_id}

#### GET
##### Summary:

Get an Audit Log

##### Parameters

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |
| audit_id | path |  | Yes | string |
| authorization | header |  | No | string |
| fiware-service | header |  | No | string |
| fiware-servicepath | header |  | No | string |

##### Responses

| Code | Description |
| ---- | ----------- |
| 200 | Successful Response |
| 404 | Not found |
| 422 | Validation Error |

#### DELETE
##### Summary:

Delete an Audit Log for a given Tenant and Service Path

##### Parameters

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |
| audit_id | path |  | Yes | string |
| fiware-service | header |  | No | string |
| fiware-servicepath | header |  | No | string |

##### Responses

| Code | Description |
| ---- | ----------- |
| 204 | Successful Response |
| 404 | Not found |
| 422 | Validation Error |

### /v1/

#### GET
##### Summary:

Return Anubis API endpoints

##### Responses

| Code | Description |
| ---- | ----------- |
| 200 | Successful Response |

### /version/

#### GET
##### Summary:

Return the version of the Anubis API

##### Responses

| Code | Description |
| ---- | ----------- |
| 200 | Successful Response |

### /ping

#### GET
##### Summary:

Simple healthcheck endpoint

##### Responses

| Code | Description |
| ---- | ----------- |
| 200 | Successful Response |

### Models


#### AgentType

| Name | Type | Description | Required |
| ---- | ---- | ----------- | -------- |
| iri | string |  | Yes |
| name | string |  | Yes |

#### AuditLog

| Name | Type | Description | Required |
| ---- | ---- | ----------- | -------- |
| id | string |  | Yes |
| type | string |  | No |
| service | string |  | No |
| resource | string |  | No |
| resource_type | string |  | No |
| mode | string |  | No |
| decision | string |  | No |
| user | string |  | No |
| remote_ip | string |  | No |
| timestamp | dateTime |  | Yes |

#### HTTPValidationError

| Name | Type | Description | Required |
| ---- | ---- | ----------- | -------- |
| detail | [ [ValidationError](#validationerror) ] |  | No |

#### Mode

| Name | Type | Description | Required |
| ---- | ---- | ----------- | -------- |
| iri | string |  | Yes |
| name | string |  | Yes |

#### OpaDecisionLog

| Name | Type | Description | Required |
| ---- | ---- | ----------- | -------- |
| decision_id | string |  | Yes |
| input | object |  | No |
| path | string |  | No |
| labels | object |  | No |
| metrics | object |  | No |
| result | object |  | No |
| timestamp | dateTime |  | Yes |

#### Policy

| Name | Type | Description | Required |
| ---- | ---- | ----------- | -------- |
| access_to | string |  | Yes |
| resource_type | string |  | Yes |
| mode | [ string ] |  | No |
| agent | [ string ] |  | No |
| id | string |  | Yes |

#### PolicyCreate

| Name | Type | Description | Required |
| ---- | ---- | ----------- | -------- |
| access_to | string |  | Yes |
| resource_type | string |  | Yes |
| mode | [ string ] |  | No |
| agent | [ string ] |  | No |

#### ServicePath

| Name | Type | Description | Required |
| ---- | ---- | ----------- | -------- |
| path | string |  | Yes |
| id | string |  | Yes |
| tenant_id | string |  | Yes |
| parent_id | string |  | No |
| scope | string |  | No |
| children | [ [ServicePath](#servicepath) ] |  | No |

#### ServicePathCreate

| Name | Type | Description | Required |
| ---- | ---- | ----------- | -------- |
| path | string |  | Yes |

#### Tenant

| Name | Type | Description | Required |
| ---- | ---- | ----------- | -------- |
| name | string |  | Yes |
| id | string |  | Yes |
| service_paths | [ [ServicePath](#servicepath) ] |  | No |

#### TenantCreate

| Name | Type | Description | Required |
| ---- | ---- | ----------- | -------- |
| name | string |  | Yes |

#### ValidationError

| Name | Type | Description | Required |
| ---- | ---- | ----------- | -------- |
| loc | [  ] |  | Yes |
| msg | string |  | Yes |
| type | string |  | Yes |