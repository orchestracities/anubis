from fastapi.security import HTTPBearer
from typing import Optional
from fastapi import Request, HTTPException

import jwt


def parse_auth_token(token: str):
    if token:
        token = jwt.decode(token, options={"verify_signature": False})
        user_info = {}
        if "email" in token:
            user_info["email"] = token["email"]
        if "tenants" in token:
            user_info["tenants"] = token["tenants"]
        if "sub" in token:
            user_info["sub"] = token["sub"]
        if "is_super_admin" in token:
            user_info["is_super_admin"] = token["is_super_admin"]
        return user_info
    return None


def extract_auth_token(auth_string: str):
    token = auth_string.split(" ")
    if token[0] == "Bearer":
        token = token[1]
        return token
    return None


class OptionalHTTPBearer(HTTPBearer):
    async def __call__(self, request: Request) -> Optional[str]:
        from fastapi import status
        try:
            r = await super().__call__(request)
            token = r.credentials
        except HTTPException as ex:
            assert ex.status_code == status.HTTP_403_FORBIDDEN, ex
            token = None
        return token
