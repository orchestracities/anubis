# Anubis Release Notes

## 0.2-dev

### New features

- Support policy link in response Header
- Update to opa 0.38.1 and envoy 1.18
- Support filtering `/tenants/some_tenant/service_paths` by `name`
- Support filtering `/policies` by `resource` and `resourceType`
- Implement `/version` endpoint

### Bug fixes

- Fixes to FIWARE headers
- Prevented creation of duplicate policies

### Documentation

- Documentation structure and first content
- Fix code block formatting

### Continuous Integration

- Update openapi specs automatically

### Technical debt

## 0.1

### New features

- Token verification with jws, valid issuers, audience
- Env variables for configuration of Auth API endpoint, audience, valid issuers
- Default policies
- acl for policieis, tenants and servicepaths
- automatic creation of policies for entities, assigned to the user who
  successfully created the entity
- adding the graphql config inside the realm export
- change the url for the client1 in order to communicate with the frontend

### Bug fixes

### Documentation

- Improved documentation to account for new features
- Users identified by emails instead of Keycloak IDs

### Continuous Integration

- Added to workflow to account for changes
- Configurable CORS

### Technical debt

## 0.0.2

### New features

- Support for orion subscriptions in rego file
- Separate api rules from policy data
- Refactor dependencies

### Bug fixes

- Fix filesystem ownership in the docker image

### Documentation

- Improved documentation
- Fix credits text
- Document opa cli installation
- Rename project

### Continuous Integration

- Add caching and multiple python version testing
- Add docker build workflow
- Testing and full setup
- Add opa and e2e tests to ci
- Expanded tests

### Technical debt

## 0.0.1

### New features

- Basic demo

### Bug fixes

### Documentation

- Improved documentation

### Technical debt
