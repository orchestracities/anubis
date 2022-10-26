<!-- markdownlint-disable -->
# policy-governance-middleware
Specification JSONs: [v2](/api-spec/v2), [v3](/api-spec/v3).

The policy governance middleware for Anubis

## Version: 1.0.0

**License:** Apache License v2

### /metadata

#### GET
##### Summary:

/metadata

##### Responses

| Code | Description |
| ---- | ----------- |

### /mobile/policies/

#### GET
##### Summary:

/mobile/policies/

##### Responses

| Code | Description |
| ---- | ----------- |

### /mobile/policies

#### POST
##### Summary:

/mobile/policies

##### Responses

| Code | Description |
| ---- | ----------- |

### /resource/{resourceId}/provide

#### POST
##### Summary:

/resource/{resourceId}/provide

##### Parameters

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |
| resourceId | path |  | Yes | string |

##### Responses

| Code | Description |
| ---- | ----------- |

### /resource/{resourceId}/exists

#### GET
##### Summary:

/resource/{resourceId}/exists

##### Parameters

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |
| resourceId | path |  | Yes | string |

##### Responses

| Code | Description |
| ---- | ----------- |

### /resource/{resourceId}/subscribe

#### POST
##### Summary:

/resource/{resourceId}/subscribe

##### Parameters

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |
| resourceId | path |  | Yes | string |

##### Responses

| Code | Description |
| ---- | ----------- |

### /resource/{resourceId}/policy/{policyId}

#### POST
##### Summary:

/resource/{resourceId}/policy/{policyId}

##### Parameters

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |
| resourceId | path |  | Yes | string |
| policyId | path |  | Yes | string |

##### Responses

| Code | Description |
| ---- | ----------- |

#### PUT
##### Summary:

/resource/{resourceId}/policy/{policyId}

##### Parameters

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |
| resourceId | path |  | Yes | string |
| policyId | path |  | Yes | string |

##### Responses

| Code | Description |
| ---- | ----------- |

#### DELETE
##### Summary:

/resource/{resourceId}/policy/{policyId}

##### Parameters

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |
| resourceId | path |  | Yes | string |
| policyId | path |  | Yes | string |

##### Responses

| Code | Description |
| ---- | ----------- |
