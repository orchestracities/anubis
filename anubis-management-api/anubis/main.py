from fastapi import Depends, FastAPI, Response
from anubis.tenants import routers as t
from anubis.tenants import models as t_models
from anubis.policies import routers as p
from anubis.policies import models as p_models
from anubis.audit import routers as a
from anubis.audit import models as a_models
from anubis.version import ANUBIS_VERSION
from fastapi.openapi.utils import get_openapi
from anubis.database import engine

from fastapi.middleware.cors import CORSMiddleware

import os

tags_metadata = [
    {
        "name": "services",
        "description": "Manage Tenants and Service Paths",
    },
    {
        "name": "policies",
        "description": "Manage Policies for each Tenant and Service Path within a Tenant.",
    },
]

app = FastAPI()

allowed_origins = os.environ.get(
    'CORS_ALLOWED_ORIGINS', "*").replace(" ", "").split(";")
allowed_methods = os.environ.get(
    'CORS_ALLOWED_METHODS', "*").replace(" ", "").split(";")
allowed_headers = os.environ.get(
    'CORS_ALLOWED_HEADERS', "*").replace(" ", "").split(";")

app.add_middleware(
    CORSMiddleware,
    allow_origins=allowed_origins,
    allow_credentials=True,
    allow_methods=allowed_methods,
    allow_headers=allowed_headers,
)

# TODO auth
# https://docs.authlib.org/en/latest/client/fastapi.html
# https://developer.okta.com/blog/2020/12/17/build-and-secure-an-api-in-python-with-fastapi
# TODO create "tenant" in keycloak

app.include_router(t.router)
app.include_router(p.router)
app.include_router(a.router)


@app.get("/v1/", summary="Return Anubis API endpoints")
async def v1_root():
    return {
        "tenants_url": "/v1/tenants",
        "policies_url": "/v1/policies",
        "resources_url": "/v1/resources"}


@app.get("/version/", summary="Return the version of the Anubis API")
async def v1_version():
    return {
        "version": ANUBIS_VERSION}


@app.on_event("startup")
def on_startup():
    t_models.init_db()
    p_models.init_db()
    a_models.init_db()


@app.get("/ping", summary="Simple healthcheck endpoint")
async def pong():
    return {"ping": "pong!"}


def custom_openapi():
    if app.openapi_schema:
        return app.openapi_schema
    openapi_schema = get_openapi(
        title="Anubis",
        version=ANUBIS_VERSION,
        description="Anubis is a flexible Policy Enforcement solution that makes easier to reuse security policies across different services, assuming the policies entail the same resource.",
        routes=app.routes,
    )
    openapi_schema['tags'] = tags_metadata
    app.openapi_schema = openapi_schema
    return app.openapi_schema


app.openapi = custom_openapi
