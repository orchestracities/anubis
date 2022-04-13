from rdflib import Graph, URIRef, BNode, Literal
from rdflib import Namespace
from rdflib.namespace import FOAF, RDF
from policies.models import Policy
from sqlalchemy.orm import Session
import yaml
import os

acl = Namespace("http://www.w3.org/ns/auth/acl#")

# follow keycloak scheme
# user urls should be /{realm}/users/{id}
# group urls should be /{realm}/groups/{id}


def serialize(db: Session, fiware_service: [str], policies: [Policy]):
    with open(os.environ.get("DEFAULT_WAC_CONFIG_FILE", '../../config/opa-service/default_wac_config.yml'), 'r') as file:
        default_wac = yaml.load(file, Loader=yaml.FullLoader)["wac"]

    g = Graph()
    g.bind("foaf", FOAF)
    g.bind("acl", acl)

    if default_wac.get(fiware_service):
        n = Namespace(default_wac[fiware_service]["baseUrl"])
        g.bind(default_wac[fiware_service]["prefix"], n)
    else:
        n = Namespace(default_wac["default"]["baseUrl"])
        g.bind(default_wac["default"]["prefix"], n)

    for policy in policies:
        policy_node = URIRef(policy.id, n.policy)
        g.add((policy_node, RDF.type, acl.Authorization))

        mode_property = acl.mode
        for index, mode in enumerate(policy.mode):
            mode = URIRef(mode.iri, acl)
            g.add((policy_node, mode_property, mode))

        agent_class_property = acl.agentClass
        agent_property = acl.agent
        for index, agent in enumerate(policy.agent):
            agent = URIRef(agent.iri, acl)
            g.add((policy_node, agent_class_property, agent))

        if policy.access_to == "default":
            access_to_property = acl.default
            access_to_iri = URIRef("*")
        else:
            access_to_property = acl.accessTo
            if default_wac.get(fiware_service) and default_wac[fiware_service]["resourceTypeUrls"].get(
                    policy.resource_type):
                resource_namespace = Namespace(
                    default_wac[fiware_service]["resourceTypeUrls"][policy.resource_type]["url"])
                access_to_iri = URIRef(policy.access_to, resource_namespace)
            else:
                access_to_iri = URIRef(policy.access_to, n)
        g.add((policy_node, access_to_property, access_to_iri))
    return g.serialize()
