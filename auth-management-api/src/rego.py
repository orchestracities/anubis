from policies.models import Policy
from policies import operations as po
from tenants import operations as to
from sqlalchemy.orm import Session
from default import AUTHENTICATED_AGENT_ID



def package(db: Session, policy: Policy):
    if policy is not None and policy.service_path_id is not None:
        tenant_id = to.get_service_path_by_id(db, policy.service_path_id).tenant_id
        return "package enyoy.authz.{}\n\n".format(tenant_id)
    else:
        raise ValueError("no service_path")

def tenant(db: Session, policy: Policy):
    if policy is not None and policy.service_path_id is not None:
        tenant_id = to.get_service_path_by_id(db, policy.service_path_id).tenant_id
        tenant = to.get_tenant(db, tenant_id)
        return 'tenant = "{}"\n\n'.format(tenant.name)
    else:
        raise ValueError("no tenant")

def imports():
    return "import input.attributes.request.http.method as method\n" \
        "import input.attributes.request.http.path as path\n" \
        "import input.attributes.request.http.headers.authorization as authorization\n\n"

#see https://www.w3.org/wiki/WebAccessControl#WAC_relation_to_HTTP_Verbs
def scope_method():
    return 'scope_method = {"wac:Read": ["GET"], ' \
        '"wac:Write": ["POST","PUT","PATCH"], ' \
        '"wac:Control": ["GET","POST","PUT","DELETE","PATCH"], ' \
        '"wac:Append": ["POST","PATCH"]}\n\n'


def token():
    return 'token = {"payload": payload} {\n' \
        '    [header, payload, signature] := io.jwt.decode(bearer_token)\n' \
        '}\n\n' \
        'is_token_valid {\n' \
        '    now := time.now_ns() / 1000000000\n' \
        '    token.payload.nbf <= now\n' \
        '    now < token.payload.exp\n' \
        '}\n\n' \
        'bearer_token := t {\n' \
        '    v := authorization\n' \
        '    startswith(v, "Bearer ")\n' \
        '    t := substring(v, count("Bearer "), -1)\n' \
        '}\n\n'

def functions():
    return 'contains_element(arr, elem) = true {\n' \
        '    arr[_] = elem\n' \
        '} else = false { true }\n\n' \
        'subject := p {\n' \
        '    p := token.payload.sub\n' \
        '}\n\n' \
        'fiware_service := p {\n' \
        '    p := input.attributes.request.http.headers["fiware-service"]\n' \
        '}\n\n' \
        'fiware_servicepath := p {\n' \
        '    p := input.attributes.request.http.headers["fiware-servicepath"]\n' \
        '}\n\n' \

    

def defaults():
    return 'default authz = false\n\n' \
        'authz {\n' \
        '    allow\n' \
        '    not deny\n' \
        '}\n\n' \
        'default resource_allowed = false\n\n' \
        'allow {\n' \
        '    resource_allowed\n' \
        '}\n\n' \
        'deny {\n' \
        '    resource_denied\n' \
        '}\n'

#to define or we use rego incremental sets!
def serialize_policy(db: Session, policy: Policy):
    p = ""
    for index, agent in enumerate(policy.agent):
        for index, mode in enumerate(policy.mode):
            p+=resource_allowed(db, policy, mode.iri, agent.iri)
    return p

def resource_allowed(db: Session, policy: Policy, mode_iri: str, agent_iri: str):
    p = 'resource_allowed {\n'
    #check tenant
    p += '    fiware_service = tenant\n'
    #is user authenticated?
    if agent_iri == AUTHENTICATED_AGENT_ID:
        p+='    is_token_valid\n'
    #group based policy
    #groups[subject][i] == "/EKZ/admin"
    #match resource
    p += '    glob.match("{}", ["/"], path)\n'.format(policy.access_to)
    #is the action allowed?
    p += '    contains_element(scope_method["{}"], method)\n'.format(mode_iri)
    #match service path
    path = to.get_service_path_by_id(db, policy.service_path_id).path
    p += '    glob.match("{}", ["/"], fiware_servicepath)\n'.format(path)
    #done
    p += '}\n\n'
    return p

def serialize(db: Session, policies: [Policy]):
    if len(policies) > 0:
        rego = package(db, policies[0])
        rego += tenant(db, policies[0])
        rego += imports()
        rego += scope_method()
        rego += token()
        rego += functions()
        for policy in policies:
            rego += serialize_policy(db, policy)
        return rego
    else:
        raise ValueError("no policies")