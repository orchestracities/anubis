from fastapi import Depends, FastAPI
from tenants import routers as t
from policies import routers as p


app = FastAPI()

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