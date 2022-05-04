<!-- markdownlint-disable -->
# Anubis
Anubis is a flexible Policy Enforcement solution that makes easier to reuse security policies across different services, assuming the policies entail the same resource.

## Version: 0.2.0

### /v1/tenants/service_paths

#### GET
##### Summary:

Read Service Paths

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

Read Tenants

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

Create Tenant

##### Responses

| Code | Description |
| ---- | ----------- |
| 201 | Successful Response |
| 404 | Not found |
| 422 | Validation Error |

### /v1/tenants/{tenant_id}

#### GET
##### Summary:

Read Tenant

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

Delete Service

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

Read Tenant Service Paths

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

Create Service Path

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

Read Service Path

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

Delete Service Path

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

Read Modes

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

Read Modes

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

Read Policies

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

#### POST
##### Summary:

Create Policy

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

Read Policy

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

#### DELETE
##### Summary:

Delete Policy

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

### /v1/

#### GET
##### Summary:

V1 Root

##### Responses

| Code | Description |
| ---- | ----------- |
| 200 | Successful Response |

### /version/

#### GET
##### Summary:

V1 Version

##### Responses

| Code | Description |
| ---- | ----------- |
| 200 | Successful Response |

### /ping

#### GET
##### Summary:

Pong

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

#### HTTPValidationError

| Name | Type | Description | Required |
| ---- | ---- | ----------- | -------- |
| detail | [ [ValidationError](#validationerror) ] |  | No |

#### Mode

| Name | Type | Description | Required |
| ---- | ---- | ----------- | -------- |
| iri | string |  | Yes |
| name | string |  | Yes |

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
| loc | [ string ] |  | Yes |
| msg | string |  | Yes |
| type | string |  | Yes |