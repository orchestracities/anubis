import express from "express"
import expressJSDocSwagger from 'express-jsdoc-swagger'
import bp from "body-parser"
import { createLibp2p } from 'libp2p'
import { TCP } from '@libp2p/tcp'
import { WebSockets } from '@libp2p/websockets'
import { Mplex } from '@libp2p/mplex'
import { Noise } from '@chainsafe/libp2p-noise'
import { CID } from 'multiformats/cid'
import { KadDHT } from '@libp2p/kad-dht'
import all from 'it-all'
import delay from 'delay'
import { Bootstrap } from '@libp2p/bootstrap'
import * as json from 'multiformats/codecs/json'
import { sha256 } from 'multiformats/hashes/sha2'
import { FloodSub } from '@libp2p/floodsub'
import { fromString as uint8ArrayFromString } from 'uint8arrays/from-string'
import { toString as uint8ArrayToString } from 'uint8arrays/to-string'
import { MulticastDNS } from '@libp2p/mdns'
import axios from 'axios'
import fs from 'fs'
import { Multiaddr } from "@multiformats/multiaddr";
import dns from "dns/promises";
import cors from 'cors';
import logger from 'logops';
import path from 'path';
import {fileURLToPath} from 'url';

//TODO: set-up a code linter (see the configuration-api one)
//TODO: set-up some unit testing
//TODO: how to handle the special case of service paths that are (of course) duplicated?


// Configuration for the port used by this node
const server_port = process.env.SERVER_PORT || 8098
// Uri of the Anubis API connected to this middleware
const anubis_api_uri = process.env.ANUBIS_API_URI || "127.0.0.1:8085"
// The multiaddress format address this middleware listens on
const listen_address = process.env.LISTEN_ADDRESS || '/dnsaddr/localhost/tcp/49662'
// Is this a private organisation? (Private org won't share policies that aren't of a specific user only)
const is_private_org = process.env.IS_PRIVATE_ORG || "true"

// Convert DNS address to IP address (solves Docker issues)
var listen_ma = new Multiaddr(listen_address)
var options = listen_ma.toOptions()
if(listen_address.includes("dnsaddr") && options.host != 'localhost') {
  const lookup = await dns.lookup(options.host)
  listen_ma = new Multiaddr(listen_ma.toString().replace(options.host, lookup.address).replace("dnsaddr", "ip4"))
}

const __filename = fileURLToPath(import.meta.url);

const __dirname = path.dirname(__filename);

const openApiOptions = {
  info: {
    version: '0.6.0-dev',
    title: 'Policy Distribution Middleware',
    description: 'This API enables the distributed management of policies for Anubis',
    license: {
      name: 'Apache License v2',
    },
  },
  baseDir: __dirname,
  // Glob pattern to find your jsdoc files (multiple patterns can be added in an array)
  filesPattern: '*.js',
  // URL where SwaggerUI will be rendered
  swaggerUIPath: '/docs',
  // Expose OpenAPI UI
  exposeSwaggerUI: true,
  // Expose Open API JSON Docs documentation in `apiDocsPath` path.
  exposeApiDocs: true,
  // Open API JSON Docs endpoint.
  apiDocsPath: '/api-spec/v3',
  // Set non-required fields as nullable by default
  notRequiredAsNullable: false,
  // You can customize your UI options.
  // you can extend swagger-ui-express config. You can checkout an example of this
  // in the `example/configuration/swaggerOptions.js`
  swaggerUiOptions: {},
  // multiple option in case you want more that one instance
  multiple: true,
};

// Setting up Node app
var app = express()
// TODO: check if it is possible to improve auto generated openapi specs
expressJSDocSwagger(app)(openApiOptions);
app.use(cors())
app.use(bp.json())
app.use(bp.urlencoded({ extended: true }))

// Keeping track of resources being provided
var providedResources = []

var peers = []

// Setting up the Libp2p node
const node = await createLibp2p({
  addresses: {
    listen: [listen_ma]
  },
  transports: [new TCP(), new WebSockets()],
  streamMuxers: [new Mplex()],
  connectionEncryption: [new Noise()],
  dht: new KadDHT(),
  peerDiscovery: [
    new MulticastDNS({
      interval: 20e3
    })
  ],
  connectionManager: {
    autoDial: true
  },
  pubsub: new FloodSub(),
  relay: {
    enabled: true,
    hop: {
      enabled: true
    },
    advertise: {
      enabled: true,
    }
  }
})


/**
 * GET /metadata
 * @summary The metadata specific to the middleware node
 * @return {object} 200 - metadata response
 * @tags Metadata
 */
app.get('/metadata', async(req, res) => {
  res.json({"policy_api_uri": anubis_api_uri})
})


/**
 * A policy for a resource
 * @typedef {object} Policy
 * @property {string} id.required - The id of the policy
 * @property {array<string>} actorType.required - The subject of the policy 
 * @property {array<string>} mode.required - The mode of the policy
 */

/**
* A protected resource
* @typedef {object} Resource
* @property {string} id.required - The id of the resource
* @property {array<Policy>} policies.required - The policies that apply to the resource
*/

/**
* Set of resources by a user
* @typedef {object} UserResources
* @property {string} user.required - The id of the user
* @property {array<Resource>} resources.required - The resources owned by the user
*/

/**
 * GET /user/policies/
 * @summary Retrieves all the policies linked to resources owned by a given user
 * @param {string} user.header.required - user for which resource policies are retrieved
 * @param {string} fiware-Service.header - fiware service (only for private mode)
 * @param {string} fiware-Servicepath.header - fiware service path (only for private mode)
 * @return {UserResources} 200 - return all policies of a given resource owner
 * @tags User
 */
app.get('/user/policies/', async(req, res) => {
  var user = req.get('user')

  // if we are in mode public we should not get any of these.
  var service = null
  var servicepath = null

  if (is_private_org == "true") {
    if (!req.get('fiware-Service')) {
      return res.status(400).json({
        message: "fiware-Service header cannot be empty",
      })
    }
    service = req.get('fiware-Service')
    servicepath =  req.get('fiware-Servicepath') ? req.get('fiware-Servicepath') : '/'
  }

  var responseResources = []
  var responseData = {
    "user": user,
    "resources": responseResources
  }

  var resources = new Map()

  // retrieve all resources I own in the different middlewares
  for (const peerId of peers){
    var providerPolicyApi = null
    var peer = await node.peerStore.addressBook.get(peerId)
    await axios({
      method: 'get',
      url: `http://${peer[0].multiaddr.nodeAddress().address}:8098/metadata`
    })
    .then(async function (response) {
      providerPolicyApi = response.data["policy_api_uri"]
    })
    .catch(function (error) {
      logger.warn(`Can't retrieve policy API URL for provider ${peer[0].multiaddr.nodeAddress().address}`)
    })
    if(!providerPolicyApi) {
      continue
    }
    var headers = {}

    if (service) {
      headers['fiware-Service'] = service
      headers['fiware-Servicepath'] =  servicepath ? servicepath : '/'
    }

    await axios({
      method: 'get',
      url: `http://${providerPolicyApi}/v1/middleware/resources`,
      headers: headers,
      params: {
        'owner': `acl:agent:${user}`
      }
    })
    .then(async function (response) {
      for (const resource of response.data){
        if (!resources.has(resource.id)) resources.set(resource.id, resource)
      }
    })
    .catch(function (error) {
      logger.warn(error.response.data)
    })
  }

  for (const resource of resources.values()){
    const bytes = json.encode({ resource: resource.id })
    const hash = await sha256.digest(bytes)
    const cid = CID.create(1, json.code, hash)

    const newPolicies = new Map()
    
    var providers = []
    try {
      providers = await all(node.contentRouting.findProviders(cid, { timeout: 3000 }))
    }
    catch(error) {
     logger.warn(`No providers for ${resource.id}`)
    }
    for (const provider of providers) {
      var providerPolicyApi = null
      await axios({
        method: 'get',
        url: `http://${provider.multiaddrs[0].nodeAddress().address}:8098/metadata`
      })
      .then(async function (response) {
        providerPolicyApi = response.data["policy_api_uri"]
      })
      .catch(function (error) {
        logger.warn(`Can't retrieve policy API URL for provider ${provider.multiaddrs[0].nodeAddress().address}`)
      })
      if(!providerPolicyApi) {
        continue
      }
      await axios({
        method: 'get',
        url: `http://${providerPolicyApi}/v1/middleware/policies`,
        headers: headers,
        params: {
          'resource': resource.id
        }
      })
      .then(async function (response) {
        for (const policy_entry of response.data) {
          const newPolicy = {"id": policy_entry["id"], "actorType": policy_entry["agent"], "mode": policy_entry["mode"]}
          if (!newPolicies.has(newPolicy.id))
            newPolicies.set(newPolicy.id,newPolicy)
        }
      })
      .catch(function (error) {
        logger.error(error.response.data)
      })
    }
    const newResource = {
      "id": resource.id,
      "resource_type": resource.type,
      "policies":  Array.from(newPolicies.values())
    }
    responseResources.push(newResource)
  }
  res.json(responseData)
})

/**
 * POST /user/policies/
 * @summary Updates the policies linked to resources owned by a given user
 * @param {UserResources} request.body.required - The policies to be stored in the middleware network - application/json
 * @param {string} fiware-Service.header - fiware service (only for private mode)
 * @param {string} fiware-Servicepath.header - fiware service path (only for private mode)
 * @return 200
 * @tags User
 */
app.post('/mobile/policies', async(req, res) => {
  if (!Object.keys(req.body).length) {
   return res.status(400).json({
     message: "Request body cannot be empty",
   })
  }

  // if we are in mode public we should not get any of these.
  var service = null
  var servicepath = null

  if (is_private_org == "true") {
    if (!req.get('fiware-Service')) {
      return res.status(400).json({
        message: "fiware-Service header cannot be empty",
      })
    }
    service = req.get('fiware-Service')
    servicepath =  req.get('fiware-Servicepath') ? req.get('fiware-Servicepath') : '/'
    logger.debug(payload)
  }

  var { resources, user } = req.body

  if (!resources) {
   res.status(400).json({
     message: "Ensure you sent a set of resources",
   })
  }

  for(const resource of resources) {
      const resId = resource.id
      const resType = resource.resource_type
      for(const policy of resource.policies) {
        var new_policy = {
            "id": policy.id,
            "access_to": resId,
            "resource_type": resType,
            "mode": policy.mode,
            "agent": policy.actorType
        }

        var message = {
          "action": "send_mobile",
          "policy": new_policy,
        }

        if (service) {
          message.service = service
          message.servicePath =  servicepath ? servicepath : '/'
        }

        message = JSON.stringify(message)
        await node.pubsub.publish(resId, uint8ArrayFromString(message)).catch(err => {
          logger.error(err)
          res.end(`Error: ${err}`)
        })
      }
  }
  res.end()
})

/**
 * POST /resource/{resourceId}/provide
 * @summary Register this middleware as a provider for a given resource
 * @param {string} resourceId.path.required - The resourceId provided
 * @param {string} fiware-Service.header - fiware service (only for private mode)
 * @param {string} fiware-Servicepath.header - fiware service path (only for private mode)
 * @return 200
 * @tags Resource
 */
app.post('/resource/:resourceId/provide', async(req, res) => {
  if (!req.params.resourceId) {
    return res.status(400).json({
      message: "resourceId parameters cannot be empty",
    })
  }
  var resource = decodeURI(req.params['resourceId'])

  var payload = { resource: resource }

  if (is_private_org == "true") {
    if (!req.get('fiware-Service')) {
      return res.status(400).json({
        message: "fiware-Service header cannot be empty",
      })
    }
    payload['fiware-Service'] = req.get('fiware-Service')
    payload['fiware-Servicepath'] =  req.get('fiware-Servicepath') ? req.get('fiware-Servicepath') : '/'
    logger.debug(payload)
  }

  const bytes = json.encode(payload)
  const hash = await sha256.digest(bytes)
  const cid = CID.create(1, json.code, hash)
  await node.contentRouting.provide(cid)
  providedResources.push(resource)

  var message = `Registered as policy provider for resource ${resource}`

  logger.info(message)
  res.end(message)
})


/**
 * GET /resource/{resourceId}/exists
 * @summary Checks if there is a provider for this resource
 * @param {string} resourceId.path.required - The resourceId checked
 * @param {string} fiware-Service.header - fiware service (only for private mode)
 * @param {string} fiware-Servicepath.header - fiware service path (only for private mode)
 * @return 200
 * @tags Resource
 */
app.get('/resource/:resourceId/exists', async(req, res) => {
  if (!req.params.resourceId) {
    return res.status(400).json({
      message: "resourceId parameters cannot be empty",
    })
  }
  var resource = decodeURI(req.params['resourceId'])

  var payload = { resource: resource }

  if (is_private_org == "true") {
    if (!req.get('fiware-Service')) {
      return res.status(400).json({
        message: "fiware-Service header cannot be empty",
      })
    }
    payload['fiware-Service'] = req.get('fiware-Service')
    payload['fiware-Servicepath'] =  req.get('fiware-Servicepath') ? req.get('fiware-Servicepath') : '/'
    logger.debug(payload)
  }

  const bytes = json.encode(payload)
  const hash = await sha256.digest(bytes)
  const cid = CID.create(1, json.code, hash)

  var providers = []
  try {
    providers = await all(node.contentRouting.findProviders(cid, { timeout: 3000 }))
  }
  catch(error) {
    res.send(false)
    return
  }
  res.send(true)
})


/**
 * POST /resource/{resourceId}/subscribe
 * @summary Subscribe this middleware to a given resource
 * @param {string} resourceId.path.required - The resourceId provided
 * @param {string} fiware-Service.header - fiware service (required only in public mode)
 * @param {string} fiware-Servicepath.header - fiware service path (required only in public mode)
 * @return 200
 * @tags Resource
 */
app.post('/resource/:resourceId/subscribe', async(req, res) => {
  if (!req.params.resourceId) {
    return res.status(400).json({
      message: "resourceId parameters cannot be empty",
    })
  }
  var resource = decodeURI(req.params['resourceId'])

  var payload = { resource: resource }

  var topic = resource

  if (is_private_org == "true") {
    if (!req.get('fiware-Service')) {
      return res.status(400).json({
        message: "fiware-Service header cannot be empty",
      })
    }
    payload['fiware-Service'] = req.get('fiware-Service')
    payload['fiware-Servicepath'] =  req.get('fiware-Servicepath') ? req.get('fiware-Servicepath') : '/'
    topic = payload['fiware-Service']+'#'+payload['fiware-Servicepath']+'#'+resource
    logger.debug(payload)
  }

  const topics = await node.pubsub.getTopics()
  if (!topics.includes(topic)) {
    await node.pubsub.subscribe(topic)
    logger.info(`Subscribed to ${topic}`)
  }

  const bytes = json.encode(payload)
  const hash = await sha256.digest(bytes)
  const cid = CID.create(1, json.code, hash)

  var providers = []
  try {
    providers = await all(node.contentRouting.findProviders(cid, { timeout: 3000 }))
  }
  catch(error) {
    res.end(`Subscribed to ${topic}, no other providers found`)
    return
  }
  logger.info(`Syncing with other providers for ${resource} ...`)
  for (const provider of providers) {
    var providerPolicyApi = null
    await axios({
      method: 'get',
      url: `http://${provider.multiaddrs[0].nodeAddress().address}:8098/metadata`
    })
    .then(async function (response) {
      providerPolicyApi = response.data["policy_api_uri"]
    })
    .catch(function (error) {
      logger.warn(`Can't retrieve policy API URL for provider ${provider.multiaddrs[0].nodeAddress().address}`)
    })
    if(!providerPolicyApi) {
      continue
    }
    var headers = {}
    if (is_private_org == "true") {
      headers['fiware-Service'] = req.get('fiware-Service')
      headers['fiware-Servicepath'] =  req.get('fiware-Servicepath') ? req.get('fiware-Servicepath') : '/'
    }
    //if no headers I should get all policies on a resource
    await axios({
      method: 'get',
      url: `http://${providerPolicyApi}/v1/middleware/policies`,
      headers: headers,
      params: {
        'resource': resource
      }
    })
    .then(async function (response) {
      for (const policy_entry of response.data) {
        // TODO: Concurrency
        if(is_private_org != "true") {
          var filtered_agents = policy_entry.agent.filter(a => (!a.includes("acl:agent:") && !a.includes("acl:AuthenticatedAgent") && !a.includes("foaf:Agent")))
          if(filtered_agents.length > 0) {
            continue
          }
        }
        // while in public mode we don't use headers for the retrieval, to post resources in correct
        // tenant were we want the resource to be created, we leverage them (if any)
        if (req.get('fiware-Service')){
          headers['fiware-Service'] = req.get('fiware-Service')
          headers['fiware-Servicepath'] =  req.get('fiware-Servicepath') ? req.get('fiware-Servicepath') : '/'
        }
        await axios({
          method: 'post',
          url: `http://${anubis_api_uri}/v1/middleware/policies`,
          headers: headers,
          data: policy_entry
        })
        .then(function (r) {
          logger.debug(r.data)
        })
        .catch(function (err) {
          if (err.response){
            logger.error(err.response.data)
          } else {
            logger.error(err.message)
          }
        })
      }
    })
    .catch(function (error) {
      if (error.response){
        logger.error(error.response.data)
      } else {
        logger.error(error.message)
      }
    })
  }
  res.end(`Subscribed to ${resource}`)
})

/**
 * POST /resource/{resourceId}/policy/{policyId}
 * @summary Notify this middleware that a new policy was created for a given resource
 * @param {string} resourceId.path.required - The resourceId of the resource for which the new policy creation is notified
 * @param {string} policyId.path.required - The policyId of the new policy
 * @param {string} fiware-Service.header - fiware service (required only in private mode)
 * @param {string} fiware-Servicepath.header - fiware service path (required only in private mode)
 * @return 200
 * @tags Resource
 */
app.post('/resource/:resourceId/policy/:policyId', async(req, res) => {
  if (!req.params.resourceId) {
    return res.status(400).json({
      message: "resourceId parameters cannot be empty",
    })
  }
  if (!req.params.policyId) {
    return res.status(400).json({
      message: "policyId parameters cannot be empty",
    })
  }

  var resource = decodeURI(req.params['resourceId'])
  var policy_id = req.params['policyId']

  var message = {
    "action": "post",
    "policy_id": policy_id,
  }

  var topic = resource

  if (is_private_org == "true") {
    if (!req.get('fiware-Service')) {
      return res.status(400).json({
        message: "fiware-Service header cannot be empty",
      })
    }
    message.service = req.get('fiware-Service')
    message.servicePath =  req.get('fiware-Servicepath') ? req.get('fiware-Servicepath') : '/'
    topic = message.service+'#'+message.servicePath+'#'+resource
    logger.debug(message)
  }

  message = JSON.stringify(message)
  await node.pubsub.publish(topic, uint8ArrayFromString(message)).catch(err => {
    console.error(err)
    res.end(`Error: ${err}`)
  })

  res.end("Policy message sent: " + message)
  logger.info("Policy message sent: " + message)
})

/**
 * PUT /resource/{resourceId}/policy/{policyId}
 * @summary Notify this middleware that a policy was updated for a given resource
 * @param {string} resourceId.path.required - The resourceId of the resource for which the policy update is notified
 * @param {string} policyId.path.required - The policyId of the policy updated
 * @param {string} fiware-Service.header - fiware service (required only in private mode)
 * @param {string} fiware-Servicepath.header - fiware service path (required only in private mode)
 * @return 200
 * @tags Resource
 */
app.put('/resource/:resourceId/policy/:policyId', async(req, res) => {
  if (!req.params.resourceId) {
    return res.status(400).json({
      message: "resourceId parameters cannot be empty",
    })
  }
  if (!req.params.policyId) {
    return res.status(400).json({
      message: "policyId parameters cannot be empty",
    })
  }

  var resource = decodeURI(req.params['resourceId'])
  var policy_id = req.params['policyId']

  var message = {
    "action": "put",
    "policy_id": policy_id,
  }

  var topic = resource

  if (is_private_org == "true") {
    if (!req.get('fiware-Service')) {
      return res.status(400).json({
        message: "fiware-Service header cannot be empty",
      })
    }
    message.service = req.get('fiware-Service')
    message.servicePath =  req.get('fiware-Servicepath') ? req.get('fiware-Servicepath') : '/'
    topic = message.service+'#'+message.servicePath+'#'+resource
    logger.debug(message)
  }

  message = JSON.stringify(message)
  await node.pubsub.publish(topic, uint8ArrayFromString(message)).catch(err => {
    console.error(err)
    res.end(`Error: ${err}`)
  })

  res.end("Policy message sent: " + message)
  logger.info("Policy message sent: " + message)
})

/**
 * DELETE /resource/{resourceId}/policy/{policyId}
 * @summary Notify this middleware that a policy was deleted for a given resource
 * @param {string} resourceId.path.required - The resourceId of the resource for which the policy delete is notified
 * @param {string} policyId.path.required - The policyId of the policy deleted
 * @param {string} fiware-Service.header - fiware service (required only in private mode)
 * @param {string} fiware-Servicepath.header - fiware service path (required only in private mode)
 * @return 200
 * @tags Resource
 */
app.delete('/resource/:resourceId/policy/:policyId', async(req, res) => {
  if (!req.params.resourceId) {
    return res.status(400).json({
      message: "resourceId parameters cannot be empty",
    })
  }
  if (!req.params.policyId) {
    return res.status(400).json({
      message: "policyId parameters cannot be empty",
    })
  }

  var resource = decodeURI(req.params['resourceId'])
  var policy_id = req.params['policyId']

  var message = {
    "action": "delete",
    "policy_id": policy_id,
  }

  var topic = resource

  if (is_private_org == "true") {
    if (!req.req.get('fiware-Service')) {
      return res.status(400).json({
        message: "fiware-Service header cannot be empty",
      })
    }
    message.service = req.get('fiware-Service')
    message.servicePath =  req.get('fiware-Servicepath') ? req.get('fiware-Servicepath') : '/'
    topic = message.service+'#'+message.servicePath+'#'+resource
    logger.debug(message)
  }
  message = JSON.stringify(message)
  await node.pubsub.publish(resource, uint8ArrayFromString(message)).catch(err => {
    console.error(err)
    res.end(`Error: ${err}`)
  })

  res.end("Policy message sent: " + message)
  logger.info("Policy message sent: " + message)
})

// Function to process a message arriving on a topic (resource)
async function processTopicMessage(evt) {
  const sender = await node.peerStore.addressBook.get(evt.detail.from)
  const message = JSON.parse(uint8ArrayToString(evt.detail.data))
  logger.info(`Node received: ${uint8ArrayToString(evt.detail.data)} on topic ${evt.detail.topic}`)
  var headers = {}
  if (message.service) {
    headers['fiware-Service'] = message.service
    headers['fiware-Servicepath'] = message.servicePath ? message.servicePath : '/'
  }

  if(message.action == "send_mobile") {
    //policy exist? -> update otherwise create
    var method = 'post'
    var path =''
    await axios({
      method: 'get',
      url: `http://${anubis_api_uri}/v1/middleware/policies/${message.policy.id}`,
      headers: headers
    })
    .then(function (r) {
      method = 'put'
      path =`/${message.policy.id}`
    })
    .catch(function (err) {
      logger.error(err.response.data)
    })
    await axios({
      method: method,
      url: `http://${anubis_api_uri}/v1/middleware/policies${path}`,
      headers: headers,
      data: message.policy
    })
    .then(function (r) {
      logger.info("policy created/updated")
    })
    .catch(function (err) {
      logger.error(err.response.data)
    })
    return
  }

  // let's retrieve the metadata from the node that contacted me
  var providerPolicyApi = null
  await axios({
    method: 'get',
    url: `http://${sender[0].multiaddr.nodeAddress().address}:8098/metadata`
  })
  .then(async function (response) {
    providerPolicyApi = response.data["policy_api_uri"]
  })
  .catch(function (error) {
    logger.error(error)
  })
  if(message.action == "delete") {
    await axios({
      method: 'delete',
      url: `http://${anubis_api_uri}/v1/middleware/policies/${message.policy_id}`,
      headers: headers
    })
    .then(function (r) {
      logger.info(`deleted policy ${message.policy_id}`)
    })
    .catch(function (err) {
      logger.error(err)
    })
    return
  }
  // in case we created or updated a policy, let's retrieve it
  await axios({
    method: 'get',
    url: `http://${providerPolicyApi}/v1/middleware/policies/${message.policy_id}`,
    headers: headers
  })
  .then(async function (response) {
    if(message.action == "post") {
      await axios({
        method: 'post',
        url: `http://${anubis_api_uri}/v1/middleware/policies`,
        headers: headers,
        data: response.data
      })
      .then(function (r) {
        logger.info(`created policy ${message.policy_id}`)
      })
      .catch(function (err) {
        logger.error(err.response.data)
      })
    }
    else if(message.action == "put") {
      await axios({
        method: 'put',
        url: `http://${anubis_api_uri}/v1/middleware/policies/${message.policy_id}`,
        headers: headers,
        data: response.data
      })
      .then(function (r) {
        logger.info(`updated policy ${message.policy_id}`)
      })
      .catch(function (err) {
        logger.error(err)
      })
    }
  })
  .catch(function (error) {
    logger.error(error)
  })
}

// Saving config to file
async function saveConfiguration() {
  var persistentDataFileStream = fs.createWriteStream('data.json')
  const topics = await node.pubsub.getTopics()
  let data2 = JSON.stringify({"topics": topics, "resources": providedResources})
  persistentDataFileStream.write(data2)
  persistentDataFileStream.close()
}

// Starting server
var server = app.listen(server_port, async() => {

  await node.start()

  try {
    let rawdata = fs.readFileSync('data.json')
    let data = JSON.parse(rawdata)

    for(const resource of data.resources) {
      providedResources.push(resource)
      const bytes = json.encode({ resource: resource })
      const hash = await sha256.digest(bytes)
      const cid = CID.create(1, json.code, hash)
      try {
        await node.contentRouting.provide(cid)
      }
      catch(err) {
        logger.error(`Failed to initially provide ${resource}`)
      }
    }

    for(const topic of data.topics) {
      node.pubsub.subscribe(topic)
    }
    //TODO: we load data, but when to we write it? if we write right after creation there is data to store...
    await saveConfiguration()
  }
  catch(err) {
    logger.error("Couldn't read any initial config")
  }

  logger.info("Node started with:")
  node.getMultiaddrs().forEach((ma) => logger.info(`${ma.toString()}`))

  //why connecting twice??? also results in duplicated peers in the list!!!
  node.connectionManager.addEventListener('peer:connect', (evt) => {
    const connection = evt.detail
    logger.info('Connection established to:', connection.remotePeer.toString())
    const index = peers.indexOf(connection.remotePeer);
    if (index < 0) {
      //TODO: index of object does not work well, replace array with map
      peers.push(connection.remotePeer)
    }
  })


  node.connectionManager.addEventListener('peer:disconnect', (evt) => {
    const connection = evt.detail
    logger.info('Connection lost to:', connection.remotePeer.toString())
    const index = peers.indexOf(connection.remotePeer);
    if (index > -1) {
      //TODO: index of object does not work well, replace array with map
      peers.splice(index, 1);
    }
  })
  
  node.addEventListener('peer:discovery', async(evt) => {
    const peer = evt.detail
    if (node.peerId.toString() == peer.id.toString()) {
      return
    }
    var peerId = node.peerStore.addressBook.get(peer.id)
    if (!peerId) {
      logger.info('Discovered:', peer.id.toString())
      node.peerStore.addressBook.set(peer.id, peer.multiaddrs)
      node.dial(peer.id)
    }
  })

  await node.pubsub.addEventListener("message", (evt) => processTopicMessage(evt))

  await delay(1000)

  logger.info(`My id: ${node.peerId.toString()}`)

  var host = server.address().address
  var port = server.address().port
  logger.info("App listening at http://%s:%s", host, port)
})
