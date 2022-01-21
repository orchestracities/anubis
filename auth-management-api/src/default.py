AUTHENTICATED_AGENT_ID = 'acl:AuthenticatedAgent'
UNAUTHENTICATED_AGENT_IRI = 'foaf:Agent'
READ_MODE_IRI = 'acl:Read'
WRITE_MODE_IRI = 'acl:Write'
CONTROL_MODE_IRI = 'acl:Control'
APPEND_MODE_IRI = 'acl:Append'
AGENT_CLASS_IRI = 'acl:agentClass'
AGENT_IRI = 'acl:agent'
AGENT_GROUP_IRI = 'acl:agentGroup'
# custom
AGENT_ROLE_IRI = 'oc-acl:agentRole'
DELETE_MODE_IRI = 'oc-acl:Delete'
SAME_TENANT_AS_RESOURCE_AGENT_ID = 'oc-acl:ResourceTenantAgent'

# commodity
DEFAULT_MODES = [
    READ_MODE_IRI,
    WRITE_MODE_IRI,
    APPEND_MODE_IRI,
    CONTROL_MODE_IRI,
    DELETE_MODE_IRI]
DEFAULT_AGENTS = [
    AUTHENTICATED_AGENT_ID,
    UNAUTHENTICATED_AGENT_IRI,
    SAME_TENANT_AS_RESOURCE_AGENT_ID]
AGENT_IRI_REGEX = "^" + AGENT_CLASS_IRI + \
    r":[a-zA-Z0-9_\-]+$" + "|^" + AGENT_GROUP_IRI + r":[a-zA-Z0-9_\-]+$" + "|^" + AGENT_IRI + r":[a-zA-Z0-9_\-]+$"
