# Anubis Release Notes

## 0.5-dev

### New features

- Anonymize IP and email in logs

### Bug fixes

- Change the keycloak config file to manage the token refresh

### Documentation

- Improve architecture documentation
- End to end demo including UI

### Continuous Integration

### Technical debt

## 0.4

### New features

- Implement access logs via OPA decision log collection (#17)
- Update dependencies

### Bug fixes

- Fix models using correctly relationships

### Documentation

- Document installation
- Document data model

### Continuous Integration

### Technical debt

## 0.3

### New features

- Turtle parsing for default policies creation
- Python package for the API built and pushed onto PyPi
- Support `#` as wild char to return all policies within a service path tree
- Support policy update

### Bug fixes

- Revised method mappings, acl:Control behaviour
- Fix readme
- Fix policy filter queries with mode and agent
- Bump pyjwt from 2.3.0 to 2.4.0 in /anubis-management-api

### Documentation

- Improve documentation and provide ttl version of the vocabulary.

### Continuous Integration

### Technical debt

## 0.2

### New features

- Support policy link in response Header
- Update to opa 0.38.1 and envoy 1.18
- Support filtering `/tenants/some_tenant/service_paths` by `name`
- Support filtering `/policies` by `resource` and `resourceType`
- Support filtering `/policies` by `agentType`
- Implement `/version` endpoint
- Added config file for wac serialisation
- Support for Postgressql database

### Bug fixes

- Fixes to FIWARE headers
- Prevented creation of duplicate policies
- Fix API logging

### Documentation

- Documentation structure and first content
- Update links and follow FIWARE structure
- Fix code block formatting
- Fix architecture figure display

### Continuous Integration

- Update openapi specs automatically
- Introduce matrix test for different db type

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
