from policies.models import Policy
from policies import operations as po
from tenants import operations as to
from sqlalchemy.orm import Session
from default import AUTHENTICATED_AGENT_ID
import json


def serialize(db: Session, policies: [Policy]):
    if len(policies) > 0:
        rego = {
            "user_permissions": {},
            "group_permissions": {},
            "role_permissions": {}}
        for policy in policies:
            for agent in policy.agent:
                for mode in policy.mode:
                    if agent.iri == "acl:AuthenticatedAgent":
                        entity = "AuthenticatedAgent"
                    elif agent.iri == "foaf:Agent":
                        entity = "Agent"
                    else:
                        entity = agent.iri.split(":", 2)[2]
                    action = mode.iri
                    resource = policy.access_to
                    resource_type = policy.resource_type
                    service_path = to.get_service_path_by_id(
                        db, policy.service_path_id)
                    tenant = to.get_tenant(db, service_path.tenant_id)
                    policy_element = {
                        "action": action,
                        "resource": resource,
                        "resource_type": resource_type,
                        "service_path": service_path.path,
                        "tenant": tenant.name}
                    if agent.type == "acl:agent":
                        if rego["user_permissions"].get(entity):
                            rego["user_permissions"][entity].append(
                                policy_element)
                        else:
                            rego["user_permissions"][entity] = [policy_element]
                    elif agent.type == "acl:agentGroup":
                        if rego["group_permissions"].get(entity):
                            rego["group_permissions"][entity].append(
                                policy_element)
                        else:
                            rego["group_permissions"][entity] = [
                                policy_element]
                    elif agent.type == "acl:agentClass":
                        if rego["role_permissions"].get(entity):
                            rego["role_permissions"][entity].append(
                                policy_element)
                        else:
                            rego["role_permissions"][entity] = [policy_element]
        return json.dumps(rego)
    else:
        raise ValueError("no policies")
