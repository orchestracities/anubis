<!-- Generator: Widdershins v4.0.1 -->

<h1 id="fastapi">FastAPI v0.1.0</h1>

> Scroll down for code samples, example requests and responses. Select a language for code samples from the tabs above or the mobile navigation menu.

<h1 id="fastapi-default">Default</h1>

## v1_root_v1__get

<a id="opIdv1_root_v1__get"></a>

> Code samples

```shell
# You can also use wget
curl -X GET /v1/ \
  -H 'Accept: application/json'

```

```http
GET /v1/ HTTP/1.1

Accept: application/json

```

```javascript

const headers = {
  'Accept':'application/json'
};

fetch('/v1/',
{
  method: 'GET',

  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => 'application/json'
}

result = RestClient.get '/v1/',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Accept': 'application/json'
}

r = requests.get('/v1/', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Accept' => 'application/json',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('GET','/v1/', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("/v1/");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("GET");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Accept": []string{"application/json"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("GET", "/v1/", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`GET /v1/`

*V1 Root*

> Example responses

> 200 Response

```json
null
```

<h3 id="v1_root_v1__get-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|Successful Response|Inline|

<h3 id="v1_root_v1__get-responseschema">Response Schema</h3>

<aside class="success">
This operation does not require authentication
</aside>

<h1 id="fastapi-services">services</h1>

## read_service_paths_v1_tenants_service_paths_get

<a id="opIdread_service_paths_v1_tenants_service_paths_get"></a>

> Code samples

```shell
# You can also use wget
curl -X GET /v1/tenants/service_paths \
  -H 'Accept: application/json'

```

```http
GET /v1/tenants/service_paths HTTP/1.1

Accept: application/json

```

```javascript

const headers = {
  'Accept':'application/json'
};

fetch('/v1/tenants/service_paths',
{
  method: 'GET',

  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => 'application/json'
}

result = RestClient.get '/v1/tenants/service_paths',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Accept': 'application/json'
}

r = requests.get('/v1/tenants/service_paths', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Accept' => 'application/json',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('GET','/v1/tenants/service_paths', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("/v1/tenants/service_paths");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("GET");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Accept": []string{"application/json"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("GET", "/v1/tenants/service_paths", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`GET /v1/tenants/service_paths`

*Read Service Paths*

<h3 id="read_service_paths_v1_tenants_service_paths_get-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|skip|query|integer|false|none|
|limit|query|integer|false|none|

> Example responses

> 200 Response

```json
[
  {
    "path": "string",
    "id": "string",
    "tenant_id": "string",
    "parent_id": "string",
    "scope": "string",
    "children": []
  }
]
```

<h3 id="read_service_paths_v1_tenants_service_paths_get-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|Successful Response|Inline|
|404|[Not Found](https://tools.ietf.org/html/rfc7231#section-6.5.4)|Not found|None|
|422|[Unprocessable Entity](https://tools.ietf.org/html/rfc2518#section-10.3)|Validation Error|[HTTPValidationError](#schemahttpvalidationerror)|

<h3 id="read_service_paths_v1_tenants_service_paths_get-responseschema">Response Schema</h3>

Status Code **200**

*Response Read Service Paths V1 Tenants Service Paths Get*

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|Response Read Service Paths V1 Tenants Service Paths Get|[[ServicePath](#schemaservicepath)]|false|none|none|
|» ServicePath|[ServicePath](#schemaservicepath)|false|none|none|
|»» path|string|true|none|none|
|»» id|string|true|none|none|
|»» tenant_id|string|true|none|none|
|»» parent_id|string|false|none|none|
|»» scope|string|false|none|none|
|»» children|[[ServicePath](#schemaservicepath)]|false|none|none|
|»»» ServicePath|[ServicePath](#schemaservicepath)|false|none|none|

<aside class="success">
This operation does not require authentication
</aside>

## read_tenants_v1_tenants__get

<a id="opIdread_tenants_v1_tenants__get"></a>

> Code samples

```shell
# You can also use wget
curl -X GET /v1/tenants/ \
  -H 'Accept: application/json'

```

```http
GET /v1/tenants/ HTTP/1.1

Accept: application/json

```

```javascript

const headers = {
  'Accept':'application/json'
};

fetch('/v1/tenants/',
{
  method: 'GET',

  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => 'application/json'
}

result = RestClient.get '/v1/tenants/',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Accept': 'application/json'
}

r = requests.get('/v1/tenants/', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Accept' => 'application/json',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('GET','/v1/tenants/', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("/v1/tenants/");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("GET");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Accept": []string{"application/json"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("GET", "/v1/tenants/", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`GET /v1/tenants/`

*Read Tenants*

<h3 id="read_tenants_v1_tenants__get-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|skip|query|integer|false|none|
|limit|query|integer|false|none|

> Example responses

> 200 Response

```json
[
  {
    "name": "string",
    "id": "string",
    "service_paths": []
  }
]
```

<h3 id="read_tenants_v1_tenants__get-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|Successful Response|Inline|
|404|[Not Found](https://tools.ietf.org/html/rfc7231#section-6.5.4)|Not found|None|
|422|[Unprocessable Entity](https://tools.ietf.org/html/rfc2518#section-10.3)|Validation Error|[HTTPValidationError](#schemahttpvalidationerror)|

<h3 id="read_tenants_v1_tenants__get-responseschema">Response Schema</h3>

Status Code **200**

*Response Read Tenants V1 Tenants  Get*

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|Response Read Tenants V1 Tenants  Get|[[Tenant](#schematenant)]|false|none|none|
|» Tenant|[Tenant](#schematenant)|false|none|none|
|»» name|string|true|none|none|
|»» id|string|true|none|none|
|»» service_paths|[[ServicePath](#schemaservicepath)]|false|none|none|
|»»» ServicePath|[ServicePath](#schemaservicepath)|false|none|none|
|»»»» path|string|true|none|none|
|»»»» id|string|true|none|none|
|»»»» tenant_id|string|true|none|none|
|»»»» parent_id|string|false|none|none|
|»»»» scope|string|false|none|none|
|»»»» children|[[ServicePath](#schemaservicepath)]|false|none|none|
|»»»»» ServicePath|[ServicePath](#schemaservicepath)|false|none|none|

<aside class="success">
This operation does not require authentication
</aside>

## create_tenant_v1_tenants__post

<a id="opIdcreate_tenant_v1_tenants__post"></a>

> Code samples

```shell
# You can also use wget
curl -X POST /v1/tenants/ \
  -H 'Content-Type: application/json' \
  -H 'Accept: application/json'

```

```http
POST /v1/tenants/ HTTP/1.1

Content-Type: application/json
Accept: application/json

```

```javascript
const inputBody = '{
  "name": "string"
}';
const headers = {
  'Content-Type':'application/json',
  'Accept':'application/json'
};

fetch('/v1/tenants/',
{
  method: 'POST',
  body: inputBody,
  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Content-Type' => 'application/json',
  'Accept' => 'application/json'
}

result = RestClient.post '/v1/tenants/',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Content-Type': 'application/json',
  'Accept': 'application/json'
}

r = requests.post('/v1/tenants/', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Content-Type' => 'application/json',
    'Accept' => 'application/json',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('POST','/v1/tenants/', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("/v1/tenants/");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("POST");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Content-Type": []string{"application/json"},
        "Accept": []string{"application/json"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("POST", "/v1/tenants/", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`POST /v1/tenants/`

*Create Tenant*

> Body parameter

```json
{
  "name": "string"
}
```

<h3 id="create_tenant_v1_tenants__post-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|body|body|[TenantCreate](#schematenantcreate)|true|none|

> Example responses

> 422 Response

```json
{
  "detail": [
    {
      "loc": [
        "string"
      ],
      "msg": "string",
      "type": "string"
    }
  ]
}
```

<h3 id="create_tenant_v1_tenants__post-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|201|[Created](https://tools.ietf.org/html/rfc7231#section-6.3.2)|Successful Response|None|
|404|[Not Found](https://tools.ietf.org/html/rfc7231#section-6.5.4)|Not found|None|
|422|[Unprocessable Entity](https://tools.ietf.org/html/rfc2518#section-10.3)|Validation Error|[HTTPValidationError](#schemahttpvalidationerror)|

<aside class="success">
This operation does not require authentication
</aside>

## read_tenant_v1_tenants__tenant_id__get

<a id="opIdread_tenant_v1_tenants__tenant_id__get"></a>

> Code samples

```shell
# You can also use wget
curl -X GET /v1/tenants/{tenant_id} \
  -H 'Accept: application/json'

```

```http
GET /v1/tenants/{tenant_id} HTTP/1.1

Accept: application/json

```

```javascript

const headers = {
  'Accept':'application/json'
};

fetch('/v1/tenants/{tenant_id}',
{
  method: 'GET',

  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => 'application/json'
}

result = RestClient.get '/v1/tenants/{tenant_id}',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Accept': 'application/json'
}

r = requests.get('/v1/tenants/{tenant_id}', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Accept' => 'application/json',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('GET','/v1/tenants/{tenant_id}', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("/v1/tenants/{tenant_id}");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("GET");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Accept": []string{"application/json"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("GET", "/v1/tenants/{tenant_id}", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`GET /v1/tenants/{tenant_id}`

*Read Tenant*

<h3 id="read_tenant_v1_tenants__tenant_id__get-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|tenant_id|path|string|true|none|

> Example responses

> 200 Response

```json
{
  "name": "string",
  "id": "string",
  "service_paths": []
}
```

<h3 id="read_tenant_v1_tenants__tenant_id__get-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|Successful Response|[Tenant](#schematenant)|
|404|[Not Found](https://tools.ietf.org/html/rfc7231#section-6.5.4)|Not found|None|
|422|[Unprocessable Entity](https://tools.ietf.org/html/rfc2518#section-10.3)|Validation Error|[HTTPValidationError](#schemahttpvalidationerror)|

<aside class="success">
This operation does not require authentication
</aside>

## delete_service_v1_tenants__tenant_id__delete

<a id="opIddelete_service_v1_tenants__tenant_id__delete"></a>

> Code samples

```shell
# You can also use wget
curl -X DELETE /v1/tenants/{tenant_id} \
  -H 'Accept: application/json'

```

```http
DELETE /v1/tenants/{tenant_id} HTTP/1.1

Accept: application/json

```

```javascript

const headers = {
  'Accept':'application/json'
};

fetch('/v1/tenants/{tenant_id}',
{
  method: 'DELETE',

  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => 'application/json'
}

result = RestClient.delete '/v1/tenants/{tenant_id}',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Accept': 'application/json'
}

r = requests.delete('/v1/tenants/{tenant_id}', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Accept' => 'application/json',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('DELETE','/v1/tenants/{tenant_id}', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("/v1/tenants/{tenant_id}");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("DELETE");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Accept": []string{"application/json"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("DELETE", "/v1/tenants/{tenant_id}", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`DELETE /v1/tenants/{tenant_id}`

*Delete Service*

<h3 id="delete_service_v1_tenants__tenant_id__delete-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|tenant_id|path|string|true|none|

> Example responses

> 422 Response

```json
{
  "detail": [
    {
      "loc": [
        "string"
      ],
      "msg": "string",
      "type": "string"
    }
  ]
}
```

<h3 id="delete_service_v1_tenants__tenant_id__delete-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|204|[No Content](https://tools.ietf.org/html/rfc7231#section-6.3.5)|Successful Response|None|
|404|[Not Found](https://tools.ietf.org/html/rfc7231#section-6.5.4)|Not found|None|
|422|[Unprocessable Entity](https://tools.ietf.org/html/rfc2518#section-10.3)|Validation Error|[HTTPValidationError](#schemahttpvalidationerror)|

<aside class="success">
This operation does not require authentication
</aside>

## read_tenant_service_paths_v1_tenants__tenant_id__service_paths_get

<a id="opIdread_tenant_service_paths_v1_tenants__tenant_id__service_paths_get"></a>

> Code samples

```shell
# You can also use wget
curl -X GET /v1/tenants/{tenant_id}/service_paths \
  -H 'Accept: application/json'

```

```http
GET /v1/tenants/{tenant_id}/service_paths HTTP/1.1

Accept: application/json

```

```javascript

const headers = {
  'Accept':'application/json'
};

fetch('/v1/tenants/{tenant_id}/service_paths',
{
  method: 'GET',

  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => 'application/json'
}

result = RestClient.get '/v1/tenants/{tenant_id}/service_paths',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Accept': 'application/json'
}

r = requests.get('/v1/tenants/{tenant_id}/service_paths', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Accept' => 'application/json',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('GET','/v1/tenants/{tenant_id}/service_paths', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("/v1/tenants/{tenant_id}/service_paths");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("GET");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Accept": []string{"application/json"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("GET", "/v1/tenants/{tenant_id}/service_paths", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`GET /v1/tenants/{tenant_id}/service_paths`

*Read Tenant Service Paths*

<h3 id="read_tenant_service_paths_v1_tenants__tenant_id__service_paths_get-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|tenant_id|path|string|true|none|
|skip|query|integer|false|none|
|limit|query|integer|false|none|

> Example responses

> 200 Response

```json
[
  {
    "path": "string",
    "id": "string",
    "tenant_id": "string",
    "parent_id": "string",
    "scope": "string",
    "children": []
  }
]
```

<h3 id="read_tenant_service_paths_v1_tenants__tenant_id__service_paths_get-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|Successful Response|Inline|
|404|[Not Found](https://tools.ietf.org/html/rfc7231#section-6.5.4)|Not found|None|
|422|[Unprocessable Entity](https://tools.ietf.org/html/rfc2518#section-10.3)|Validation Error|[HTTPValidationError](#schemahttpvalidationerror)|

<h3 id="read_tenant_service_paths_v1_tenants__tenant_id__service_paths_get-responseschema">Response Schema</h3>

Status Code **200**

*Response Read Tenant Service Paths V1 Tenants  Tenant Id  Service Paths Get*

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|Response Read Tenant Service Paths V1 Tenants  Tenant Id  Service Paths Get|[[ServicePath](#schemaservicepath)]|false|none|none|
|» ServicePath|[ServicePath](#schemaservicepath)|false|none|none|
|»» path|string|true|none|none|
|»» id|string|true|none|none|
|»» tenant_id|string|true|none|none|
|»» parent_id|string|false|none|none|
|»» scope|string|false|none|none|
|»» children|[[ServicePath](#schemaservicepath)]|false|none|none|
|»»» ServicePath|[ServicePath](#schemaservicepath)|false|none|none|

<aside class="success">
This operation does not require authentication
</aside>

## create_service_path_v1_tenants__tenant_id__service_paths_post

<a id="opIdcreate_service_path_v1_tenants__tenant_id__service_paths_post"></a>

> Code samples

```shell
# You can also use wget
curl -X POST /v1/tenants/{tenant_id}/service_paths \
  -H 'Content-Type: application/json' \
  -H 'Accept: application/json'

```

```http
POST /v1/tenants/{tenant_id}/service_paths HTTP/1.1

Content-Type: application/json
Accept: application/json

```

```javascript
const inputBody = '{
  "path": "string"
}';
const headers = {
  'Content-Type':'application/json',
  'Accept':'application/json'
};

fetch('/v1/tenants/{tenant_id}/service_paths',
{
  method: 'POST',
  body: inputBody,
  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Content-Type' => 'application/json',
  'Accept' => 'application/json'
}

result = RestClient.post '/v1/tenants/{tenant_id}/service_paths',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Content-Type': 'application/json',
  'Accept': 'application/json'
}

r = requests.post('/v1/tenants/{tenant_id}/service_paths', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Content-Type' => 'application/json',
    'Accept' => 'application/json',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('POST','/v1/tenants/{tenant_id}/service_paths', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("/v1/tenants/{tenant_id}/service_paths");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("POST");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Content-Type": []string{"application/json"},
        "Accept": []string{"application/json"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("POST", "/v1/tenants/{tenant_id}/service_paths", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`POST /v1/tenants/{tenant_id}/service_paths`

*Create Service Path*

> Body parameter

```json
{
  "path": "string"
}
```

<h3 id="create_service_path_v1_tenants__tenant_id__service_paths_post-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|tenant_id|path|string|true|none|
|body|body|[ServicePathCreate](#schemaservicepathcreate)|true|none|

> Example responses

> 422 Response

```json
{
  "detail": [
    {
      "loc": [
        "string"
      ],
      "msg": "string",
      "type": "string"
    }
  ]
}
```

<h3 id="create_service_path_v1_tenants__tenant_id__service_paths_post-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|201|[Created](https://tools.ietf.org/html/rfc7231#section-6.3.2)|Successful Response|None|
|404|[Not Found](https://tools.ietf.org/html/rfc7231#section-6.5.4)|Not found|None|
|422|[Unprocessable Entity](https://tools.ietf.org/html/rfc2518#section-10.3)|Validation Error|[HTTPValidationError](#schemahttpvalidationerror)|

<aside class="success">
This operation does not require authentication
</aside>

## read_service_path_v1_tenants__tenant_id__service_paths__service_path_id__get

<a id="opIdread_service_path_v1_tenants__tenant_id__service_paths__service_path_id__get"></a>

> Code samples

```shell
# You can also use wget
curl -X GET /v1/tenants/{tenant_id}/service_paths/{service_path_id} \
  -H 'Accept: application/json'

```

```http
GET /v1/tenants/{tenant_id}/service_paths/{service_path_id} HTTP/1.1

Accept: application/json

```

```javascript

const headers = {
  'Accept':'application/json'
};

fetch('/v1/tenants/{tenant_id}/service_paths/{service_path_id}',
{
  method: 'GET',

  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => 'application/json'
}

result = RestClient.get '/v1/tenants/{tenant_id}/service_paths/{service_path_id}',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Accept': 'application/json'
}

r = requests.get('/v1/tenants/{tenant_id}/service_paths/{service_path_id}', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Accept' => 'application/json',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('GET','/v1/tenants/{tenant_id}/service_paths/{service_path_id}', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("/v1/tenants/{tenant_id}/service_paths/{service_path_id}");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("GET");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Accept": []string{"application/json"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("GET", "/v1/tenants/{tenant_id}/service_paths/{service_path_id}", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`GET /v1/tenants/{tenant_id}/service_paths/{service_path_id}`

*Read Service Path*

<h3 id="read_service_path_v1_tenants__tenant_id__service_paths__service_path_id__get-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|tenant_id|path|string|true|none|
|service_path_id|path|string|true|none|

> Example responses

> 200 Response

```json
{
  "path": "string",
  "id": "string",
  "tenant_id": "string",
  "parent_id": "string",
  "scope": "string",
  "children": []
}
```

<h3 id="read_service_path_v1_tenants__tenant_id__service_paths__service_path_id__get-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|Successful Response|[ServicePath](#schemaservicepath)|
|404|[Not Found](https://tools.ietf.org/html/rfc7231#section-6.5.4)|Not found|None|
|422|[Unprocessable Entity](https://tools.ietf.org/html/rfc2518#section-10.3)|Validation Error|[HTTPValidationError](#schemahttpvalidationerror)|

<aside class="success">
This operation does not require authentication
</aside>

## delete_service_path_v1_tenants__tenant_id__service_paths__service_path_id__delete

<a id="opIddelete_service_path_v1_tenants__tenant_id__service_paths__service_path_id__delete"></a>

> Code samples

```shell
# You can also use wget
curl -X DELETE /v1/tenants/{tenant_id}/service_paths/{service_path_id} \
  -H 'Accept: application/json'

```

```http
DELETE /v1/tenants/{tenant_id}/service_paths/{service_path_id} HTTP/1.1

Accept: application/json

```

```javascript

const headers = {
  'Accept':'application/json'
};

fetch('/v1/tenants/{tenant_id}/service_paths/{service_path_id}',
{
  method: 'DELETE',

  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => 'application/json'
}

result = RestClient.delete '/v1/tenants/{tenant_id}/service_paths/{service_path_id}',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Accept': 'application/json'
}

r = requests.delete('/v1/tenants/{tenant_id}/service_paths/{service_path_id}', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Accept' => 'application/json',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('DELETE','/v1/tenants/{tenant_id}/service_paths/{service_path_id}', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("/v1/tenants/{tenant_id}/service_paths/{service_path_id}");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("DELETE");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Accept": []string{"application/json"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("DELETE", "/v1/tenants/{tenant_id}/service_paths/{service_path_id}", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`DELETE /v1/tenants/{tenant_id}/service_paths/{service_path_id}`

*Delete Service Path*

<h3 id="delete_service_path_v1_tenants__tenant_id__service_paths__service_path_id__delete-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|tenant_id|path|string|true|none|
|service_path_id|path|string|true|none|

> Example responses

> 422 Response

```json
{
  "detail": [
    {
      "loc": [
        "string"
      ],
      "msg": "string",
      "type": "string"
    }
  ]
}
```

<h3 id="delete_service_path_v1_tenants__tenant_id__service_paths__service_path_id__delete-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|204|[No Content](https://tools.ietf.org/html/rfc7231#section-6.3.5)|Successful Response|None|
|404|[Not Found](https://tools.ietf.org/html/rfc7231#section-6.5.4)|Not found|None|
|422|[Unprocessable Entity](https://tools.ietf.org/html/rfc2518#section-10.3)|Validation Error|[HTTPValidationError](#schemahttpvalidationerror)|

<aside class="success">
This operation does not require authentication
</aside>

<h1 id="fastapi-policies">policies</h1>

## read_modes_v1_policies_access_modes_get

<a id="opIdread_modes_v1_policies_access_modes_get"></a>

> Code samples

```shell
# You can also use wget
curl -X GET /v1/policies/access-modes \
  -H 'Accept: application/json'

```

```http
GET /v1/policies/access-modes HTTP/1.1

Accept: application/json

```

```javascript

const headers = {
  'Accept':'application/json'
};

fetch('/v1/policies/access-modes',
{
  method: 'GET',

  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => 'application/json'
}

result = RestClient.get '/v1/policies/access-modes',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Accept': 'application/json'
}

r = requests.get('/v1/policies/access-modes', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Accept' => 'application/json',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('GET','/v1/policies/access-modes', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("/v1/policies/access-modes");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("GET");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Accept": []string{"application/json"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("GET", "/v1/policies/access-modes", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`GET /v1/policies/access-modes`

*Read Modes*

<h3 id="read_modes_v1_policies_access_modes_get-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|skip|query|integer|false|none|
|limit|query|integer|false|none|

> Example responses

> 200 Response

```json
[
  {
    "iri": "string",
    "name": "string"
  }
]
```

<h3 id="read_modes_v1_policies_access_modes_get-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|Successful Response|Inline|
|404|[Not Found](https://tools.ietf.org/html/rfc7231#section-6.5.4)|Not found|None|
|422|[Unprocessable Entity](https://tools.ietf.org/html/rfc2518#section-10.3)|Validation Error|[HTTPValidationError](#schemahttpvalidationerror)|

<h3 id="read_modes_v1_policies_access_modes_get-responseschema">Response Schema</h3>

Status Code **200**

*Response Read Modes V1 Policies Access Modes Get*

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|Response Read Modes V1 Policies Access Modes Get|[[Mode](#schemamode)]|false|none|none|
|» Mode|[Mode](#schemamode)|false|none|none|
|»» iri|string|true|none|none|
|»» name|string|true|none|none|

<aside class="success">
This operation does not require authentication
</aside>

## read_modes_v1_policies_agent_types_get

<a id="opIdread_modes_v1_policies_agent_types_get"></a>

> Code samples

```shell
# You can also use wget
curl -X GET /v1/policies/agent-types \
  -H 'Accept: application/json'

```

```http
GET /v1/policies/agent-types HTTP/1.1

Accept: application/json

```

```javascript

const headers = {
  'Accept':'application/json'
};

fetch('/v1/policies/agent-types',
{
  method: 'GET',

  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => 'application/json'
}

result = RestClient.get '/v1/policies/agent-types',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Accept': 'application/json'
}

r = requests.get('/v1/policies/agent-types', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Accept' => 'application/json',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('GET','/v1/policies/agent-types', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("/v1/policies/agent-types");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("GET");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Accept": []string{"application/json"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("GET", "/v1/policies/agent-types", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`GET /v1/policies/agent-types`

*Read Modes*

<h3 id="read_modes_v1_policies_agent_types_get-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|skip|query|integer|false|none|
|limit|query|integer|false|none|

> Example responses

> 200 Response

```json
[
  {
    "iri": "string",
    "name": "string"
  }
]
```

<h3 id="read_modes_v1_policies_agent_types_get-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|Successful Response|Inline|
|404|[Not Found](https://tools.ietf.org/html/rfc7231#section-6.5.4)|Not found|None|
|422|[Unprocessable Entity](https://tools.ietf.org/html/rfc2518#section-10.3)|Validation Error|[HTTPValidationError](#schemahttpvalidationerror)|

<h3 id="read_modes_v1_policies_agent_types_get-responseschema">Response Schema</h3>

Status Code **200**

*Response Read Modes V1 Policies Agent Types Get*

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|Response Read Modes V1 Policies Agent Types Get|[[AgentType](#schemaagenttype)]|false|none|none|
|» AgentType|[AgentType](#schemaagenttype)|false|none|none|
|»» iri|string|true|none|none|
|»» name|string|true|none|none|

<aside class="success">
This operation does not require authentication
</aside>

## read_policies_v1_policies__get

<a id="opIdread_policies_v1_policies__get"></a>

> Code samples

```shell
# You can also use wget
curl -X GET /v1/policies/ \
  -H 'Accept: application/json' \
  -H 'fiware-service: string' \
  -H 'fiware-servicepath: string' \
  -H 'accept: string'

```

```http
GET /v1/policies/ HTTP/1.1

Accept: application/json
fiware-service: string
fiware-servicepath: string
accept: string

```

```javascript

const headers = {
  'Accept':'application/json',
  'fiware-service':'string',
  'fiware-servicepath':'string',
  'accept':'string'
};

fetch('/v1/policies/',
{
  method: 'GET',

  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => 'application/json',
  'fiware-service' => 'string',
  'fiware-servicepath' => 'string',
  'accept' => 'string'
}

result = RestClient.get '/v1/policies/',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Accept': 'application/json',
  'fiware-service': 'string',
  'fiware-servicepath': 'string',
  'accept': 'string'
}

r = requests.get('/v1/policies/', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Accept' => 'application/json',
    'fiware-service' => 'string',
    'fiware-servicepath' => 'string',
    'accept' => 'string',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('GET','/v1/policies/', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("/v1/policies/");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("GET");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Accept": []string{"application/json"},
        "fiware-service": []string{"string"},
        "fiware-servicepath": []string{"string"},
        "accept": []string{"string"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("GET", "/v1/policies/", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`GET /v1/policies/`

*Read Policies*

<h3 id="read_policies_v1_policies__get-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|mode|query|string|false|none|
|agent|query|string|false|none|
|resource|query|string|false|none|
|resource_type|query|string|false|none|
|skip|query|integer|false|none|
|limit|query|integer|false|none|
|fiware-service|header|string|false|none|
|fiware-servicepath|header|string|false|none|
|accept|header|string|false|none|

> Example responses

> 200 Response

```json
[
  {
    "access_to": "string",
    "resource_type": "string",
    "mode": [],
    "agent": [],
    "id": "string"
  }
]
```

<h3 id="read_policies_v1_policies__get-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|Success|string|
|404|[Not Found](https://tools.ietf.org/html/rfc7231#section-6.5.4)|Not found|None|
|422|[Unprocessable Entity](https://tools.ietf.org/html/rfc2518#section-10.3)|Validation Error|[HTTPValidationError](#schemahttpvalidationerror)|

<aside class="success">
This operation does not require authentication
</aside>

## create_policy_v1_policies__post

<a id="opIdcreate_policy_v1_policies__post"></a>

> Code samples

```shell
# You can also use wget
curl -X POST /v1/policies/ \
  -H 'Content-Type: application/json' \
  -H 'Accept: application/json' \
  -H 'fiware-service: string' \
  -H 'fiware-servicepath: string'

```

```http
POST /v1/policies/ HTTP/1.1

Content-Type: application/json
Accept: application/json
fiware-service: string
fiware-servicepath: string

```

```javascript
const inputBody = '{
  "access_to": "string",
  "resource_type": "string",
  "mode": [],
  "agent": []
}';
const headers = {
  'Content-Type':'application/json',
  'Accept':'application/json',
  'fiware-service':'string',
  'fiware-servicepath':'string'
};

fetch('/v1/policies/',
{
  method: 'POST',
  body: inputBody,
  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Content-Type' => 'application/json',
  'Accept' => 'application/json',
  'fiware-service' => 'string',
  'fiware-servicepath' => 'string'
}

result = RestClient.post '/v1/policies/',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Content-Type': 'application/json',
  'Accept': 'application/json',
  'fiware-service': 'string',
  'fiware-servicepath': 'string'
}

r = requests.post('/v1/policies/', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Content-Type' => 'application/json',
    'Accept' => 'application/json',
    'fiware-service' => 'string',
    'fiware-servicepath' => 'string',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('POST','/v1/policies/', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("/v1/policies/");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("POST");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Content-Type": []string{"application/json"},
        "Accept": []string{"application/json"},
        "fiware-service": []string{"string"},
        "fiware-servicepath": []string{"string"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("POST", "/v1/policies/", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`POST /v1/policies/`

*Create Policy*

> Body parameter

```json
{
  "access_to": "string",
  "resource_type": "string",
  "mode": [],
  "agent": []
}
```

<h3 id="create_policy_v1_policies__post-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|fiware-service|header|string|false|none|
|fiware-servicepath|header|string|false|none|
|body|body|[PolicyCreate](#schemapolicycreate)|true|none|

> Example responses

> 422 Response

```json
{
  "detail": [
    {
      "loc": [
        "string"
      ],
      "msg": "string",
      "type": "string"
    }
  ]
}
```

<h3 id="create_policy_v1_policies__post-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|201|[Created](https://tools.ietf.org/html/rfc7231#section-6.3.2)|Successful Response|None|
|404|[Not Found](https://tools.ietf.org/html/rfc7231#section-6.5.4)|Not found|None|
|422|[Unprocessable Entity](https://tools.ietf.org/html/rfc2518#section-10.3)|Validation Error|[HTTPValidationError](#schemahttpvalidationerror)|

<aside class="success">
This operation does not require authentication
</aside>

## read_policy_v1_policies__policy_id__get

<a id="opIdread_policy_v1_policies__policy_id__get"></a>

> Code samples

```shell
# You can also use wget
curl -X GET /v1/policies/{policy_id} \
  -H 'Accept: application/json' \
  -H 'fiware-service: string' \
  -H 'fiware-servicepath: string' \
  -H 'accept: string'

```

```http
GET /v1/policies/{policy_id} HTTP/1.1

Accept: application/json
fiware-service: string
fiware-servicepath: string
accept: string

```

```javascript

const headers = {
  'Accept':'application/json',
  'fiware-service':'string',
  'fiware-servicepath':'string',
  'accept':'string'
};

fetch('/v1/policies/{policy_id}',
{
  method: 'GET',

  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => 'application/json',
  'fiware-service' => 'string',
  'fiware-servicepath' => 'string',
  'accept' => 'string'
}

result = RestClient.get '/v1/policies/{policy_id}',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Accept': 'application/json',
  'fiware-service': 'string',
  'fiware-servicepath': 'string',
  'accept': 'string'
}

r = requests.get('/v1/policies/{policy_id}', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Accept' => 'application/json',
    'fiware-service' => 'string',
    'fiware-servicepath' => 'string',
    'accept' => 'string',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('GET','/v1/policies/{policy_id}', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("/v1/policies/{policy_id}");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("GET");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Accept": []string{"application/json"},
        "fiware-service": []string{"string"},
        "fiware-servicepath": []string{"string"},
        "accept": []string{"string"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("GET", "/v1/policies/{policy_id}", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`GET /v1/policies/{policy_id}`

*Read Policy*

<h3 id="read_policy_v1_policies__policy_id__get-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|policy_id|path|string|true|none|
|skip|query|integer|false|none|
|limit|query|integer|false|none|
|fiware-service|header|string|false|none|
|fiware-servicepath|header|string|false|none|
|accept|header|string|false|none|

> Example responses

> 200 Response

```json
{
  "access_to": "string",
  "resource_type": "string",
  "mode": [],
  "agent": [],
  "id": "string"
}
```

<h3 id="read_policy_v1_policies__policy_id__get-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|Success|string|
|404|[Not Found](https://tools.ietf.org/html/rfc7231#section-6.5.4)|Not found|None|
|422|[Unprocessable Entity](https://tools.ietf.org/html/rfc2518#section-10.3)|Validation Error|[HTTPValidationError](#schemahttpvalidationerror)|

<aside class="success">
This operation does not require authentication
</aside>

## delete_policy_v1_policies__policy_id__delete

<a id="opIddelete_policy_v1_policies__policy_id__delete"></a>

> Code samples

```shell
# You can also use wget
curl -X DELETE /v1/policies/{policy_id} \
  -H 'Accept: application/json' \
  -H 'fiware-service: string' \
  -H 'fiware-servicepath: string'

```

```http
DELETE /v1/policies/{policy_id} HTTP/1.1

Accept: application/json
fiware-service: string
fiware-servicepath: string

```

```javascript

const headers = {
  'Accept':'application/json',
  'fiware-service':'string',
  'fiware-servicepath':'string'
};

fetch('/v1/policies/{policy_id}',
{
  method: 'DELETE',

  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => 'application/json',
  'fiware-service' => 'string',
  'fiware-servicepath' => 'string'
}

result = RestClient.delete '/v1/policies/{policy_id}',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Accept': 'application/json',
  'fiware-service': 'string',
  'fiware-servicepath': 'string'
}

r = requests.delete('/v1/policies/{policy_id}', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Accept' => 'application/json',
    'fiware-service' => 'string',
    'fiware-servicepath' => 'string',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('DELETE','/v1/policies/{policy_id}', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("/v1/policies/{policy_id}");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("DELETE");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Accept": []string{"application/json"},
        "fiware-service": []string{"string"},
        "fiware-servicepath": []string{"string"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("DELETE", "/v1/policies/{policy_id}", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`DELETE /v1/policies/{policy_id}`

*Delete Policy*

<h3 id="delete_policy_v1_policies__policy_id__delete-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|policy_id|path|string|true|none|
|fiware-service|header|string|false|none|
|fiware-servicepath|header|string|false|none|

> Example responses

> 422 Response

```json
{
  "detail": [
    {
      "loc": [
        "string"
      ],
      "msg": "string",
      "type": "string"
    }
  ]
}
```

<h3 id="delete_policy_v1_policies__policy_id__delete-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|204|[No Content](https://tools.ietf.org/html/rfc7231#section-6.3.5)|Successful Response|None|
|404|[Not Found](https://tools.ietf.org/html/rfc7231#section-6.5.4)|Not found|None|
|422|[Unprocessable Entity](https://tools.ietf.org/html/rfc2518#section-10.3)|Validation Error|[HTTPValidationError](#schemahttpvalidationerror)|

<aside class="success">
This operation does not require authentication
</aside>

# Schemas

<h2 id="tocS_AgentType">AgentType</h2>
<!-- backwards compatibility -->
<a id="schemaagenttype"></a>
<a id="schema_AgentType"></a>
<a id="tocSagenttype"></a>
<a id="tocsagenttype"></a>

```json
{
  "iri": "string",
  "name": "string"
}

```

AgentType

### Properties

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|iri|string|true|none|none|
|name|string|true|none|none|

<h2 id="tocS_HTTPValidationError">HTTPValidationError</h2>
<!-- backwards compatibility -->
<a id="schemahttpvalidationerror"></a>
<a id="schema_HTTPValidationError"></a>
<a id="tocShttpvalidationerror"></a>
<a id="tocshttpvalidationerror"></a>

```json
{
  "detail": [
    {
      "loc": [
        "string"
      ],
      "msg": "string",
      "type": "string"
    }
  ]
}

```

HTTPValidationError

### Properties

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|detail|[[ValidationError](#schemavalidationerror)]|false|none|none|

<h2 id="tocS_Mode">Mode</h2>
<!-- backwards compatibility -->
<a id="schemamode"></a>
<a id="schema_Mode"></a>
<a id="tocSmode"></a>
<a id="tocsmode"></a>

```json
{
  "iri": "string",
  "name": "string"
}

```

Mode

### Properties

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|iri|string|true|none|none|
|name|string|true|none|none|

<h2 id="tocS_Policy">Policy</h2>
<!-- backwards compatibility -->
<a id="schemapolicy"></a>
<a id="schema_Policy"></a>
<a id="tocSpolicy"></a>
<a id="tocspolicy"></a>

```json
{
  "access_to": "string",
  "resource_type": "string",
  "mode": [],
  "agent": [],
  "id": "string"
}

```

Policy

### Properties

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|access_to|string|true|none|none|
|resource_type|string|true|none|none|
|mode|[string]|false|none|none|
|agent|[string]|false|none|none|
|id|string|true|none|none|

<h2 id="tocS_PolicyCreate">PolicyCreate</h2>
<!-- backwards compatibility -->
<a id="schemapolicycreate"></a>
<a id="schema_PolicyCreate"></a>
<a id="tocSpolicycreate"></a>
<a id="tocspolicycreate"></a>

```json
{
  "access_to": "string",
  "resource_type": "string",
  "mode": [],
  "agent": []
}

```

PolicyCreate

### Properties

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|access_to|string|true|none|none|
|resource_type|string|true|none|none|
|mode|[string]|false|none|none|
|agent|[string]|false|none|none|

<h2 id="tocS_ServicePath">ServicePath</h2>
<!-- backwards compatibility -->
<a id="schemaservicepath"></a>
<a id="schema_ServicePath"></a>
<a id="tocSservicepath"></a>
<a id="tocsservicepath"></a>

```json
{
  "path": "string",
  "id": "string",
  "tenant_id": "string",
  "parent_id": "string",
  "scope": "string",
  "children": []
}

```

ServicePath

### Properties

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|path|string|true|none|none|
|id|string|true|none|none|
|tenant_id|string|true|none|none|
|parent_id|string|false|none|none|
|scope|string|false|none|none|
|children|[[ServicePath](#schemaservicepath)]|false|none|none|

<h2 id="tocS_ServicePathCreate">ServicePathCreate</h2>
<!-- backwards compatibility -->
<a id="schemaservicepathcreate"></a>
<a id="schema_ServicePathCreate"></a>
<a id="tocSservicepathcreate"></a>
<a id="tocsservicepathcreate"></a>

```json
{
  "path": "string"
}

```

ServicePathCreate

### Properties

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|path|string|true|none|none|

<h2 id="tocS_Tenant">Tenant</h2>
<!-- backwards compatibility -->
<a id="schematenant"></a>
<a id="schema_Tenant"></a>
<a id="tocStenant"></a>
<a id="tocstenant"></a>

```json
{
  "name": "string",
  "id": "string",
  "service_paths": []
}

```

Tenant

### Properties

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|name|string|true|none|none|
|id|string|true|none|none|
|service_paths|[[ServicePath](#schemaservicepath)]|false|none|none|

<h2 id="tocS_TenantCreate">TenantCreate</h2>
<!-- backwards compatibility -->
<a id="schematenantcreate"></a>
<a id="schema_TenantCreate"></a>
<a id="tocStenantcreate"></a>
<a id="tocstenantcreate"></a>

```json
{
  "name": "string"
}

```

TenantCreate

### Properties

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|name|string|true|none|none|

<h2 id="tocS_ValidationError">ValidationError</h2>
<!-- backwards compatibility -->
<a id="schemavalidationerror"></a>
<a id="schema_ValidationError"></a>
<a id="tocSvalidationerror"></a>
<a id="tocsvalidationerror"></a>

```json
{
  "loc": [
    "string"
  ],
  "msg": "string",
  "type": "string"
}

```

ValidationError

### Properties

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|loc|[string]|true|none|none|
|msg|string|true|none|none|
|type|string|true|none|none|

