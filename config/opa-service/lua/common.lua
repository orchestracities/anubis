local OBJDEF = {}

local decodejwt = (loadfile "/etc/envoy-config/opa-service/lua/decodejwt.lua")()
local JSON = (loadfile "/etc/envoy-config/opa-service/lua/JSON.lua")()

function OBJDEF:context_broker_request(request_handle)
  chunks = {}
  raw_auth_header = request_handle:headers():get("authorization")
  for substring in raw_auth_header:gmatch("%S+") do
     table.insert(chunks, substring)
  end
  token = decodejwt:decode_jwt(chunks[2])
  content_type = request_handle:headers():get("content-type")
  if content_type == "application/json" then
    local body = request_handle:body()
    local body_size = body:length()
    local body_bytes = body:getBytes(0, body_size)
    local raw_json_text = tostring(body_bytes)
    lua_value = JSON:decode(raw_json_text)
    access_to = lua_value.id
  end
  request_handle:streamInfo():dynamicMetadata():set("envoy.filters.http.lua", "request.info", {
    request_method = request_handle:headers():get(":method"),
    request_path = request_handle:headers():get(":path"),
    fiwareservice = request_handle:headers():get("fiware-service"),
    fiwareservicepath = request_handle:headers():get("fiware-servicepath"),
    authority = request_handle:headers():get(":authority"),
    userid = token.claims.email,
    access_to = access_to
  })
end

function OBJDEF:context_broker_response(response_handle)
  local meta = response_handle:streamInfo():dynamicMetadata():get("envoy.filters.http.lua")["request.info"]
  if (meta.request_method == "POST" and meta.request_path == "/v2/entities" and meta.access_to and response_handle:headers():get(":status") == "201") then
    local headers, body = response_handle:httpCall(
    "policyapi-service",
    {
      [":method"] = "POST",
      [":path"] = "/v1/policies/",
      [":authority"] = meta.authority,
      ["Content-Type"] = "application/json",
      ["fiware_service"] = meta.fiwareservice,
      ["fiware_service_path"] = meta.fiwareservicepath,
    },
    '{"access_to": "'..meta.access_to..'", "resource_type": "entity", "mode": ["acl:Control"], "agent": ["acl:agent:'..meta.userid..'"]}',
    5000,
    false)
  end
end

function OBJDEF:management_api_request(request_handle)
  chunks = {}
  raw_auth_header = request_handle:headers():get("authorization")
  for substring in raw_auth_header:gmatch("%S+") do
     table.insert(chunks, substring)
  end
  token = decodejwt:decode_jwt(chunks[2])
  request_handle:streamInfo():dynamicMetadata():set("envoy.filters.http.lua", "request.info", {
    request_method = request_handle:headers():get(":method"),
    request_path = request_handle:headers():get(":path"),
    fiwareservice = request_handle:headers():get("fiware-service"),
    fiwareservicepath = request_handle:headers():get("fiware-servicepath"),
    authority = request_handle:headers():get(":authority"),
    userid = token.claims.email
  })
end

function OBJDEF:management_api_response(response_handle)
  local meta = response_handle:streamInfo():dynamicMetadata():get("envoy.filters.http.lua")["request.info"]
  if (meta.request_method == "POST" and meta.request_path == "/v1/policies/" and response_handle:headers():get(":status") == "201") then
    local headers, body = response_handle:httpCall(
    "policyapi-service",
    {
      [":method"] = "POST",
      [":path"] = "/v1/policies/",
      [":authority"] = meta.authority,
      ["Content-Type"] = "application/json",
      ["fiware_service"] = meta.fiwareservice,
      ["fiware_service_path"] = meta.fiwareservicepath,
    },
    '{"access_to": "'..response_handle:headers():get("policy-id")..'", "resource_type": "policy", "mode": ["acl:Control"], "agent": ["acl:agent:'..meta.userid..'"]}',
    5000,
    false)
  end
end

OBJDEF.__index = OBJDEF

function OBJDEF:new(args)
   local new = { }

   if args then
      for key, val in pairs(args) do
         new[key] = val
      end
   end

   return setmetatable(new, OBJDEF)
end

return OBJDEF:new()
