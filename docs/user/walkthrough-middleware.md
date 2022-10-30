<!-- markdownlint-disable -->
# Policy Distribution Middleware
This API enables the distributed management of policies for Anubis

## Version: 0.6.0-dev

### Terms of service


**License:** [Apache License v2]()

### /metadata

#### GET
##### Summary:

The metadata specific to the middleware node

##### Parameters

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |

##### Responses

| Code | Description |
| ---- | ----------- |
| 200 | metadata response |

null

### /user/policies/

#### GET
##### Summary:

Retrieves all the policies linked to resources owned by a given user

##### Parameters

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |
| user | header | user for which resource policies are retrieved | Yes | string |
| fiware-Service | header | fiware service (only for private mode) | No | string |
| fiware-Servicepath | header | fiware service path (only for private mode) | No | string |

##### Responses

| Code | Description |
| ---- | ----------- |
| 200 | return all policies of a given resource owner |

null

#### POST
##### Summary:

Updates the policies linked to resources owned by a given user

##### Parameters

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |
| fiware-Service | header | fiware service (only for private mode) | No | string |
| fiware-Servicepath | header | fiware service path (only for private mode) | No | string |

##### Responses

| Code | Description |
| ---- | ----------- |
| 200 | Ok |
| 400 | Failed |

null

### /resource/{resourceId}/provide

#### POST
##### Summary:

Register this middleware as a provider for a given resource

##### Parameters

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |
| resourceId | path | The resourceId provided | Yes | string |
| fiware-Service | header | fiware service (only for private mode) | No | string |
| fiware-Servicepath | header | fiware service path (only for private mode) | No | string |

##### Responses

| Code | Description |
| ---- | ----------- |
| 200 | Ok |
| 400 | Failed |

null

### /resource/{resourceId}/exists

#### GET
##### Summary:

Checks if there is a provider for this resource

##### Parameters

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |
| resourceId | path | The resourceId checked | Yes | string |
| fiware-Service | header | fiware service (only for private mode) | No | string |
| fiware-Servicepath | header | fiware service path (only for private mode) | No | string |

##### Responses

| Code | Description |
| ---- | ----------- |
| 200 | Ok |
| 400 | Failed |

null

### /resource/{resourceId}/subscribe

#### POST
##### Summary:

Subscribe this middleware to a given resource

##### Parameters

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |
| resourceId | path | The resourceId provided | Yes | string |
| fiware-Service | header | fiware service (required only in public mode) | No | string |
| fiware-Servicepath | header | fiware service path (required only in public mode) | No | string |

##### Responses

| Code | Description |
| ---- | ----------- |
| 200 | Ok |
| 400 | Failed |

null

### /resource/{resourceId}/policy/{policyId}

#### POST
##### Summary:

Notify this middleware that a new policy was created for a given resource

##### Parameters

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |
| resourceId | path | The resourceId of the resource for which the new policy creation is notified | Yes | string |
| policyId | path | The policyId of the new policy | Yes | string |
| fiware-Service | header | fiware service (required only in private mode) | No | string |
| fiware-Servicepath | header | fiware service path (required only in private mode) | No | string |

##### Responses

| Code | Description |
| ---- | ----------- |
| 200 | Ok |
| 400 | Failed |

null

#### PUT
##### Summary:

Notify this middleware that a policy was updated for a given resource

##### Parameters

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |
| resourceId | path | The resourceId of the resource for which the policy update is notified | Yes | string |
| policyId | path | The policyId of the policy updated | Yes | string |
| fiware-Service | header | fiware service (required only in private mode) | No | string |
| fiware-Servicepath | header | fiware service path (required only in private mode) | No | string |

##### Responses

| Code | Description |
| ---- | ----------- |
| 200 | Ok |
| 400 | Failed |

null

#### DELETE
##### Summary:

Notify this middleware that a policy was deleted for a given resource

##### Parameters

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |
| resourceId | path | The resourceId of the resource for which the policy delete is notified | Yes | string |
| policyId | path | The policyId of the policy deleted | Yes | string |
| fiware-Service | header | fiware service (required only in private mode) | No | string |
| fiware-Servicepath | header | fiware service path (required only in private mode) | No | string |

##### Responses

| Code | Description |
| ---- | ----------- |
| 200 | Ok |
| 400 | Failed |

null

### Models


#### Metadata

A metadata entry

| Name | Type | Description | Required |
| ---- | ---- | ----------- | -------- |
| policy_api_uri | string | Anubis API endpoint for this middleware | No |

#### Policy

A policy for a resource

| Name | Type | Description | Required |
| ---- | ---- | ----------- | -------- |
| id | string | The id of the policy | Yes |
| actorType | [ string ] | The subject of the policy | Yes |
| mode | [ string ] | The mode of the policy | Yes |

#### Resource

A protected resource

| Name | Type | Description | Required |
| ---- | ---- | ----------- | -------- |
| id | string | The id of the resource | Yes |
| policies | [ [Policy](#policy) ] | The policies that apply to the resource | Yes |

#### UserResources

Set of resources by a user

| Name | Type | Description | Required |
| ---- | ---- | ----------- | -------- |
| user | string | The id of the user | Yes |
| resources | [ [Resource](#resource) ] | The resources owned by the user | Yes |