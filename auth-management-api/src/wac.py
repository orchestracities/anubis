from rdflib import Graph, URIRef, BNode, Literal
from rdflib import Namespace
from rdflib.namespace import FOAF, RDF
from policies.models import Policy
from sqlalchemy.orm import Session

n = Namespace("http://example.org/")
acl = Namespace("http://www.w3.org/ns/auth/acl#")


# follow keycloak scheme
# user urls should be /{realm}/users/{id}
# group urls should be /{realm}/groups/{id}

def serialize(db: Session, policies: [Policy]):
    g = Graph()
    g.bind("foaf", FOAF)
    g.bind("example", n)
    g.bind("acl", acl)

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

        access_to_property = acl.accessTo
        access_to_iri = URIRef(policy.access_to, n)
        g.add((policy_node, access_to_property, access_to_iri))
    return g.serialize()
