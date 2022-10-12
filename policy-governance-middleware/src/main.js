import express from "express"
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

// Configuration for the port used by this node
const server_port = process.env.SERVER_PORT || 8099
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

// Setting up Node app
var app = express()
app.use(bp.json())
app.use(bp.urlencoded({ extended: true }))

// Keeping track of resources being provided
var providedResources = []

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

// Endpoint to retrieve node metadata
app.get('/metadata', async(req, res) => {
  res.json({"policy_api_uri": anubis_api_uri})
})

// Endpoint for receiving resources from the mobile app
app.post('/resource/mobile/retrieve', async(req, res) => {
  if (!Object.keys(req.body).length) {
   return res.status(400).json({
     message: "Request body cannot be empty",
   })
  }
  var { resource, service, servicepath } = req.body
  if (!resource) {
   res.status(400).json({
     message: "Ensure you sent a resource field",
   })
  }
  if (!service) {
   res.status(400).json({
     message: "Ensure you sent a service field",
   })
  }
  if (!servicepath) {
   res.status(400).json({
     message: "Ensure you sent a servicepath field",
   })
  }

  // TODO: Email of the user
  var responseData = [
      {
          "usrMail": "test@gmail.com",
          "usrData": [
              {
                  "id": resource,
                  "description": "test",
                  "children": []
              }
          ]
      }
  ]

  const bytes = json.encode({ resource: resource })
  const hash = await sha256.digest(bytes)
  const cid = CID.create(1, json.code, hash)

  var providers = []
  try {
    providers = await all(node.contentRouting.findProviders(cid, { timeout: 3000 }))
  }
  catch(error) {
    res.end(`No providers for ${resource}`)
    return
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
      console.log(`Can't retrieve policy API URL for provider ${provider.multiaddrs[0].nodeAddress().address}`)
    })
    if(!providerPolicyApi) {
      continue
    }
    await axios({
      method: 'get',
      url: `http://${providerPolicyApi}/v1/policies`,
      headers: {
        'fiware-Service': service,
        'fiware-Servicepath': servicepath
      },
      params: {
        'resource': resource
      }
    })
    .then(async function (response) {
      for (const policy_entry of response.data) {
        if(is_private_org != "true") {
          var filtered_agents = policy_entry.agent.filter(a => !a.includes("acl:agent:"))
          if(filtered_agents.length > 0) {
            continue
          }
        }
        responseData[0].usrData[0].children.push({"id": policy_entry["id"], "actorType": policy_entry["agent"], "mode": policy_entry["mode"]})
      }
    })
    .catch(function (error) {
      console.log(error.response.data)
    })
  }
  res.json({responseData})
})

// Endpoint for providing a resource from the mobile app
app.post('/resource/mobile/send', async(req, res) => {
  if (!Object.keys(req.body).length) {
   return res.status(400).json({
     message: "Request body cannot be empty",
   })
  }
  var { policies, service, servicepath } = req.body
  if (!policies) {
   res.status(400).json({
     message: "Ensure you sent a policies field",
   })
  }
  if (!service) {
   res.status(400).json({
     message: "Ensure you sent a service field",
   })
  }
  if (!servicepath) {
   res.status(400).json({
     message: "Ensure you sent a servicepath field",
   })
  }
  for(const entry of policies) {
    const usrMail = entry.usrMail
    for(const resource of entry.usrData) {
      const resId = resource.id
      for(const policy of resource.children) {
        var modes = []
        for(const m of policy.mode.split(",")) {
          modes.push(m)
        }
        modes = modes.filter(e => e != '')
        var new_policy = {
            "id": policy.id,
            "access_to": resId,
            "resource_type": "mobile",
            "mode": modes,
            "agent": [
                policy.actorType
            ]
        }
        var message = {
          "action": "send_mobile",
          "policy": new_policy,
          "service": service,
          "servicepath": servicepath,
        }
        message = JSON.stringify(message)
        await node.pubsub.publish(resId, uint8ArrayFromString(message)).catch(err => {
          console.error(err)
          res.end(`Error: ${err}`)
        })
      }
    }
  }
  res.json({})
})

// Endpoint for providing a resource
app.post('/resource/provide', async(req, res) => {
  if (!Object.keys(req.body).length) {
   return res.status(400).json({
     message: "Request body cannot be empty",
   })
  }
  var { resource, policy, service, servicepath } = req.body
  if (!resource) {
   res.status(400).json({
     message: "Ensure you sent a resource field",
   })
  }

  const bytes = json.encode({ resource: resource })
  const hash = await sha256.digest(bytes)
  const cid = CID.create(1, json.code, hash)
  await node.contentRouting.provide(cid)
  providedResources.push(resource)

  console.log(`Provided policy for resource ${resource}`)
  res.end(`Provided policy for resource ${resource}`)
})

// Endpoint for subscribing to a resource topic
app.post('/resource/subscribe', async(req, res) => {
  if (!Object.keys(req.body).length) {
   return res.status(400).json({
     message: "Request body cannot be empty",
   })
  }
  var { resource, policy, service, servicepath } = req.body
  if (!resource) {
   res.status(400).json({
     message: "Ensure you sent a resource field",
   })
  }
  if (!service) {
   res.status(400).json({
     message: "Ensure you sent a service field",
   })
  }
  if (!servicepath) {
   res.status(400).json({
     message: "Ensure you sent a servicepath field",
   })
  }

  const topics = await node.pubsub.getTopics()
  if (!topics.includes(resource)) {
    await node.pubsub.subscribe(resource)
    console.log(`Subscribed to ${resource}`)
  }

  const bytes = json.encode({ resource: resource })
  const hash = await sha256.digest(bytes)
  const cid = CID.create(1, json.code, hash)

  var providers = []
  try {
    providers = await all(node.contentRouting.findProviders(cid, { timeout: 3000 }))
  }
  catch(error) {
    res.end(`Subscribed to ${resource}, no other providers found`)
    return
  }
  console.log(`Syncing with other providers for ${resource}...`)
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
      console.log(`Can't retrieve policy API URL for provider ${provider.multiaddrs[0].nodeAddress().address}`)
    })
    if(!providerPolicyApi) {
      continue
    }
    await axios({
      method: 'post',
      url: `http://${anubis_api_uri}/v1/tenants/`,
      data: {"name": service}
    })
    .then(async function (response) {
      console.log(`Created Tenant ${service}`)
    })
    .catch(function (error) {
      console.log(`No new Tenant created`)
    })
    await axios({
      method: 'get',
      url: `http://${providerPolicyApi}/v1/policies`,
      headers: {
        'fiware-Service': service,
        'fiware-Servicepath': servicepath
      },
      params: {
        'resource': resource
      }
    })
    .then(async function (response) {
      for (const policy_entry of response.data) {
        // TODO: Concurrency
        if(is_private_org != "true") {
          var filtered_agents = policy_entry.agent.filter(a => !a.includes("acl:agent:"))
          if(filtered_agents.length > 0) {
            continue
          }
        }
        await axios({
          method: 'post',
          url: `http://${anubis_api_uri}/v1/policies`,
          headers: {
            'fiware-Service': service,
            'fiware-Servicepath': servicepath
          },
          data: policy_entry
        })
        .then(function (r) {
          console.log(r.data)
        })
        .catch(function (err) {
          console.log(err.response.data)
        })
      }
    })
    .catch(function (error) {
      console.log(error.response.data)
    })
  }
  res.end(`Subscribed to ${resource}`)
})

// Endpoint when a new policy is created
app.post('/resource/policy/new', async(req, res) => {
  if (!Object.keys(req.body).length) {
   return res.status(400).json({
     message: "Request body cannot be empty",
   })
  }
  var { resource, policy, service, servicepath } = req.body
  if (!resource) {
   res.status(400).json({
     message: "Ensure you sent a resource field",
   })
  }
  if (!policy) {
   res.status(400).json({
     message: "Ensure you sent a policy field",
   })
  }
  if (!service) {
   res.status(400).json({
     message: "Ensure you sent a service field",
   })
  }
  if (!servicepath) {
   res.status(400).json({
     message: "Ensure you sent a servicepath field",
   })
  }

  var message = {
    "action": "post",
    "policy_id": policy,
    "service": service,
    "servicepath": servicepath,
  }
  message = JSON.stringify(message)
  await node.pubsub.publish(resource, uint8ArrayFromString(message)).catch(err => {
    console.error(err)
    res.end(`Error: ${err}`)
  })

  res.end("Policy message sent: " + message)
  console.log("Policy message sent: " + message)
})

// Endpoint when a policy is updated
app.post('/resource/policy/update', async(req, res) => {
  if (!Object.keys(req.body).length) {
   return res.status(400).json({
     message: "Request body cannot be empty",
   })
  }
  var { resource, policy, service, servicepath } = req.body
  if (!resource) {
   res.status(400).json({
     message: "Ensure you sent a resource field",
   })
  }
  if (!policy) {
   res.status(400).json({
     message: "Ensure you sent a policy field",
   })
  }
  if (!service) {
   res.status(400).json({
     message: "Ensure you sent a service field",
   })
  }
  if (!servicepath) {
   res.status(400).json({
     message: "Ensure you sent a servicepath field",
   })
  }

  var message = {
    "action": "put",
    "policy_id": policy,
    "service": service,
    "servicepath": servicepath,
  }
  message = JSON.stringify(message)
  await node.pubsub.publish(resource, uint8ArrayFromString(message)).catch(err => {
    console.error(err)
    res.end(`Error: ${err}`)
  })

  res.end("Policy message sent: " + message)
  console.log("Policy message sent: " + message)
})

// Endpoint when a policy is deleted
app.post('/resource/policy/delete', async(req, res) => {
  if (!Object.keys(req.body).length) {
   return res.status(400).json({
     message: "Request body cannot be empty",
   })
  }
  var { resource, policy, service, servicepath } = req.body
  if (!resource) {
   res.status(400).json({
     message: "Ensure you sent a resource field",
   })
  }
  if (!policy) {
   res.status(400).json({
     message: "Ensure you sent a policy field",
   })
  }
  if (!service) {
   res.status(400).json({
     message: "Ensure you sent a service field",
   })
  }
  if (!servicepath) {
   res.status(400).json({
     message: "Ensure you sent a servicepath field",
   })
  }

  var message = {
    "action": "delete",
    "policy_id": policy,
    "service": service,
    "servicepath": servicepath,
  }
  message = JSON.stringify(message)
  await node.pubsub.publish(resource, uint8ArrayFromString(message)).catch(err => {
    console.error(err)
    res.end(`Error: ${err}`)
  })

  res.end("Policy message sent: " + message)
  console.log("Policy message sent: " + message)
})

// Function to process a message arriving on a topic (resource)
async function processTopicMessage(evt) {
  const sender = await node.peerStore.addressBook.get(evt.detail.from)
  const message = JSON.parse(uint8ArrayToString(evt.detail.data))
  console.log(`Node received: ${uint8ArrayToString(evt.detail.data)} on topic ${evt.detail.topic}`)
  if(message.action == "send_mobile") {
    await axios({
      method: 'post',
      url: `http://${anubis_api_uri}/v1/tenants/`,
      data: {"name": message.service}
    })
    .then(async function (response) {
      console.log(`Created Tenant ${message.service}`)
    })
    .catch(function (error) {
      console.log(error)
    })
    await axios({
      method: 'post',
      url: `http://${anubis_api_uri}/v1/policies`,
      headers: {
        'fiware-Service': message.service,
        'fiware-Servicepath': message.servicepath
      },
      data: message.policy
    })
    .then(function (r) {
      console.log(r)
    })
    .catch(function (err) {
      console.log(err.response.data)
    })
    return
  }
  var providerPolicyApi = null
  await axios({
    method: 'get',
    url: `http://${sender[0].multiaddr.nodeAddress().address}:8098/metadata`
  })
  .then(async function (response) {
    providerPolicyApi = response.data["policy_api_uri"]
  })
  .catch(function (error) {
    console.log(error)
  })
  if(message.action == "delete") {
    await axios({
      method: 'delete',
      url: `http://${anubis_api_uri}/v1/policies/${message.policy_id}`,
      headers: {
        'fiware-Service': message.service,
        'fiware-Servicepath': message.servicepath
      },
      data: response.data
    })
    .then(function (r) {
      console.log(r)
    })
    .catch(function (err) {
      console.log(err)
    })
    return
  }
  await axios({
    method: 'get',
    url: `http://${providerPolicyApi}/v1/policies/${message.policy_id}`,
    headers: {
      'fiware-Service': message.service,
      'fiware-Servicepath': message.servicepath
    }
  })
  .then(async function (response) {
    if(message.action == "post") {
      await axios({
        method: 'post',
        url: `http://${anubis_api_uri}/v1/tenants/`,
        data: {"name": message.service}
      })
      .then(async function (response) {
        console.log(`Created Tenant ${resource}`)
      })
      .catch(function (error) {
        console.log(error)
      })
      await axios({
        method: 'post',
        url: `http://${anubis_api_uri}/v1/policies`,
        headers: {
          'fiware-Service': message.service,
          'fiware-Servicepath': message.servicepath
        },
        data: response.data
      })
      .then(function (r) {
        console.log(r)
      })
      .catch(function (err) {
        console.log(err.response.data)
      })
    }
    else if(message.action == "put") {
      await axios({
        method: 'put',
        url: `http://${anubis_api_uri}/v1/policies/${message.policy_id}`,
        headers: {
          'fiware-Service': message.service,
          'fiware-Servicepath': message.servicepath
        },
        data: response.data
      })
      .then(function (r) {
        console.log(r)
      })
      .catch(function (err) {
        console.log(err)
      })
    }
  })
  .catch(function (error) {
    console.log(error)
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
      console.log(`Failed to initially provide ${resource}`)
    }
  }

  for(const topic of data.topics) {
    node.pubsub.subscribe(topic)
  }

  await saveConfiguration()

  console.log("Node started with:")
  node.getMultiaddrs().forEach((ma) => console.log(`${ma.toString()}`))

  node.connectionManager.addEventListener('peer:connect', (evt) => {
    const connection = evt.detail
    console.log('Connection established to:', connection.remotePeer.toString())
  })

  node.addEventListener('peer:discovery', async(evt) => {
    const peer = evt.detail
    if (node.peerId.toString() == peer.id.toString()) {
      return
    }
    var peerId = node.peerStore.addressBook.get(peer.id)
    if (!peerId) {
      console.log('Discovered:', peer.id.toString())
      node.peerStore.addressBook.set(peer.id, peer.multiaddrs)
      node.dial(peer.id)
    }
  })

  await node.pubsub.addEventListener("message", (evt) => processTopicMessage(evt))

  await delay(1000)

  console.log(node.peerId.toString())

  var host = server.address().address
  var port = server.address().port
  console.log("App listening at http://%s:%s", host, port)
})
