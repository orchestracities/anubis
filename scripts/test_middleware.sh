curl --location --request GET 'localhost:8086/v1/policies?resource=resource1' \
--header 'fiware-service: Mobile' \
--header 'fiware-servicepath: /'


curl --location --request POST 'Localhost:8099/resource/subscribe' \
--header 'Content-Type: application/json' \
--data-raw '{
    "service": "Mobile",
    "servicepath": "/",
    "resource": "resource1"
}'


curl --location --request POST 'localhost:8098/resource/mobile/send' \
--header 'Content-Type: application/json' \
--data-raw '{
    "service": "Mobile",
    "servicepath": "/",
    "policies": [
        {
            "usrMail": "test@gmail.com",
            "usrData": [
                {
                    "id": "resource1",
                    "description": "test",
                    "children": [
                        {
                            "id": "f2d0ab66-6aba-4aea-b6c4-aabc66cbe34f",
                            "actorType": "acl:AuthenticatedAgent",
                            "mode": ",acl:Write"
                        },
                        {
                            "id": "66d44dc6-00a6-4134-9b12-37879b5cc0a4",
                            "actorType": "acl:AuthenticatedAgent",
                            "mode": ",acl:Write,acl:Control"
                        },
                        {
                            "id": "f3e7a891-7320-476b-905f-9bf9e2b9b176",
                            "actorType": "acl:agent:test@gmail.com",
                            "mode": ",acl:Write"
                        }
                    ]
                },
                {
                    "id": "Urn:xxx:yyy-ecab956c-d2d9-4e69-bafc-a1d899d3280b",
                    "description": "test2",
                    "children": []
                },
                {
                    "id": "resource2",
                    "description": "test3",
                    "children": []
                }
            ]
        }
    ]
}'


curl --location --request POST 'Localhost:8099/resource/provide' \
--header 'Content-Type: application/json' \
--data-raw '{
    "resource": "resource1"
}'


curl --location --request POST 'localhost:8099/resource/mobile/retrieve' \
--header 'Content-Type: application/json' \
--data-raw '{
    "service": "Mobile",
    "servicepath": "/",
    "resource": "resource1" 
}'
