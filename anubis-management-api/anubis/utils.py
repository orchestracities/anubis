from fastapi.security import HTTPBearer
from typing import Optional
from fastapi import Request, HTTPException

import jwt


def parse_auth_token(token: str):
    if token:
        token = jwt.decode(token, options={"verify_signature": False})
        user_info = {"email": token["email"], "tenants": token["tenants"]}
        return user_info
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
