from fastapi import Depends, FastAPI
from tenants import routers as t
from policies import routers as p
from version import ANUBIS_VERSION

from fastapi.openapi.utils import get_openapi

from fastapi.middleware.cors import CORSMiddleware

import os

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


@app.get("/v1/")
async def v1_root():
    return {
        "tenants_url": "/v1/tenants",
        "policies_url": "/v1/policies",
        "resources_url": "/v1/resources"}


@app.get("/version/")
async def v1_version():
    return {
        "version": ANUBIS_VERSION}


def custom_openapi():
    if app.openapi_schema:
        return app.openapi_schema
    openapi_schema = get_openapi(
        title="Anubis",
        version="0.2.0-dev",
        description="Anubis is a flexible Policy Enforcement solution that makes easier to reuse security policies across different services, assuming the policies entail the same resource.",
        routes=app.routes,
    )
    app.openapi_schema = openapi_schema
    return app.openapi_schema


app.openapi = custom_openapi
