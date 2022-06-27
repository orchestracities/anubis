import jwt


def parse_auth_token(auth_string: str):
    token = auth_string.split(" ")
    if token[0] == "Bearer":
        token = token[1]
        token = jwt.decode(token, options={"verify_signature": False})
        user_info = {}
        user_info["email"] = token["email"]
        user_info["tenants"] = token["tenants"]
        return user_info
    return None
