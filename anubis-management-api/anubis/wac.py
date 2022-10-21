from rdflib import Graph, URIRef, BNode, Literal
from rdflib import Namespace
from rdflib.namespace import FOAF, RDF, NamespaceManager
from anubis.policies.models import Policy
from sqlalchemy.orm import Session
import yaml
import os

acl = Namespace("http://www.w3.org/ns/auth/acl#")
oc_acl = Namespace("http://voc.orchestracities.io/oc-acl#")


def parse_rdf_graph(data):
    g = Graph()
    g.bind("acl", acl)
    g.bind("oc_acl", oc_acl)
    g.parse(data=data)
    nm = NamespaceManager(g)
    policies = {}
    for subj, pred, obj in g:
        policy = str(subj).split("/")[-1]
        if not policies.get(policy):
            policies[policy] = {}
        if pred == acl.agentClass:
            policies[policy]["agentClass"] = redux(str(nm.normalizeUri(obj)))
        if pred == acl.mode:
            policies[policy]["mode"] = redux(str(nm.normalizeUri(obj)))
        # TODO deal with this better.
        if pred == acl.accessTo:
            policies[policy]["accessTo"] = str(obj).split("/")[-1]
        if pred == acl.default:
            policies[policy]["accessTo"] = "default"
        if pred == acl.accessToClass:
            policies[policy]["accessToClass"] = str(
                nm.normalizeUri(obj)).split(":")[-1]
    return policies


def redux(uri: str):
    if "http://www.w3.org/ns/auth/acl#" in uri:
        return "acl:" + uri[len("http://www.w3.org/ns/auth/acl#") + 1:-1]
    if "http://voc.orchestracities.io/oc-acl#" in uri:
        return "oc-acl:" + \
            uri[len("http://voc.orchestracities.io/oc-acl#") + 1:-1]
    if "http://xmlns.com/foaf/0.1/" in uri:
        return "foaf:" + uri[len("http://xmlns.com/foaf/0.1/") + 1:-1]
    if "<" in uri[0] and ">" in uri[-1]:
        return uri[1:-1]
    return uri


def serialize(
        db: Session,
        fiware_service: [str],
        fiware_servicepath: [str],
        policies: [Policy]):
    with open(os.environ.get("DEFAULT_WAC_CONFIG_FILE", '../config/opa-service/default_wac_config.yml'), 'r') as file:
        default_wac = yaml.load(file, Loader=yaml.FullLoader)["wac"]

    g = Graph()
    g.bind("foaf", FOAF)
    g.bind("acl", acl)
    g.bind("oc_acl", oc_acl)

    if default_wac.get(fiware_service):
        n = Namespace(default_wac[fiware_service]["baseUrl"])
        g.bind(default_wac[fiware_service]["prefix"], n)
    else:
        n = Namespace(default_wac["default"]["baseUrl"])
        g.bind(default_wac["default"]["prefix"], n)
        fiware_service = "default"

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
            access_to_value = fiware_servicepath
        else:
            access_to_property = acl.accessTo
            access_to_value = policy.access_to
        if default_wac.get(fiware_service) and default_wac[fiware_service]["resourceTypeUrls"].get(
                policy.resource_type):
            resource_namespace = Namespace(
                default_wac[fiware_service]["resourceTypeUrls"][policy.resource_type]["url"])
            resource_type_namespace = Namespace(
                default_wac[fiware_service]["resourceTypeUrls"][policy.resource_type]["type_url"])
            access_to_iri = URIRef(access_to_value, resource_namespace)
            g.add((policy_node, access_to_property, access_to_iri))
            access_to_class_iri = URIRef(
                policy.resource_type, resource_type_namespace)
            g.add((policy_node, acl.accessToClass, access_to_class_iri))
        else:
            access_to_iri = URIRef(access_to_value, n)
            g.add((policy_node, access_to_property, access_to_iri))
            access_to_class_iri = URIRef(policy.resource_type, n)
            g.add((policy_node, acl.accessToClass, access_to_class_iri))

    return g.serialize()
