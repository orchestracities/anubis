# Anubis Release Notes

## 0.0.3

### New features

- Token verification with jws, valid issuers, audience
- Env variables for configuration of Auth API endpoint, audience, valid issuers
- Default policies
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
