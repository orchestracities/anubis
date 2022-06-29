from anubis.tenants.models import Tenant, ServicePath
from anubis.policies.models import Policy, Agent, Mode, AgentType
from anubis.audit.models import AuditLog
from sqlalchemy_schemadisplay import create_uml_graph
from sqlalchemy.orm import class_mapper


def mappers(*args):
    return [class_mapper(x) for x in args]


# pass them to the function and set some formatting options
graph = create_uml_graph(mappers(Tenant, ServicePath, Policy, Agent, Mode, AgentType, AuditLog),
                         show_operations=False,  # not necessary in this case
                         show_multiplicity_one=True  # some people like to see the ones, some don't
                         )
graph.write_png('../docs/admin/datamodel.png')  # write out the file
