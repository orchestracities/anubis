# Anubis Release Notes

## 0.7-dev

### New features

- Add drop all for models
- Push model for policies, plus scheduler for pushing on the hour
- /me endpoint for policies shows foaf:Agent type policies when no token
  provided

### Bug fixes

- Fix method name for retrieving agent types
- Updated user policy path (#183)
- Fix demo script configuration to UI 0.6 changes
- Fix potential issue in LUA script for policy creation on entity creation
- Added counter header in responses to policy GETs
- Fixed issues with /me endpoint not retrieving policies correctly
- Ordering for polciies and tenants to avoid pagination issues

### Documentation

- Fix logo alignment in README.MD

### Continuous Integration

- Update libraries version in setup.py
- Update github action versions

### Technical debt

## 0.6

### New features

- Endpoint for listing managed resources (i.e. resources for which there is
  an `acl:Control` policy)
- Middleware for policy distribution

### Bug fixes

### Documentation

- Revise docs (including logo)

### Continuous Integration

### Technical debt

## 0.5

### New features

- Anonymize IP and email in audit logs
- Create Tenant in Keycloak on Tenant creation on the API
- Create group Admin as Tenant subgroup on Tenant creation
- Add role tenant-admin to Admin subgroup on Tenant creation
- Add user creating tenant to Admin subgroup
- Add /me endpoint under /policy to retrieve policies that applies to a user
- Delete Tenant in Keycloak on Tenant delete on the API

### Bug fixes

- Fix support for groups including `/` in the name
- Change the keycloak config file to manage the token refresh
- Missing database entry for oc-acl:Delete
- Correct parsing / serialisation of policies (still something to be checked)

### Documentation

- Improve architecture documentation
- End to end demo including UI

### Continuous Integration

- Support automatic issue generation from TODOs
- Load tests

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
- change the url for the ngsi in order to communicate with the frontend

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
