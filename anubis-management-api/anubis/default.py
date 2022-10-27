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
DELETE_MODE_IRI = 'oc-acl:Delete'
SAME_TENANT_AS_RESOURCE_AGENT_ID = 'oc-acl:ResourceTenantAgent'
DEFAULT = 'default'

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
    SAME_TENANT_AS_RESOURCE_AGENT_ID,
    DEFAULT]
DEFAULT_AGENT_TYPES = [
    AGENT_IRI,
    AGENT_CLASS_IRI,
    AGENT_GROUP_IRI
]
AGENT_IRI_REGEX = "^" + AGENT_CLASS_IRI + \
    r":[a-zA-Z0-9_\-]+$" + "|^" + AGENT_GROUP_IRI + r":[a-zA-Z0-9_\-\/]+$" + "|^" + AGENT_IRI + r":[a-zA-Z0-9_\-\@\.]+$"
