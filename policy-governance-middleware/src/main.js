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
import { peerIdFromString } from '@libp2p/peer-id'
import fs from 'fs'

// Configuration for the port used by this node
const server_port = process.env.SERVER_PORT || 8099
const anubis_api_uri = process.env.ANUBIS_API_URI || "127.0.0.1:8085"
const listen_address = process.env.LISTEN_ADDRESS || '/ip4/127.0.0.1/tcp/0'
const peerIdString = process.env.PEERID_STRING || 'bafzbeia7rezbp2hac3fv66ndq3v3f2dvxregrvaz2nfw5aejesokvmlwq4'

if(process.env.NODE_BOOTSTRAPERS) {
  var bootstrapers = JSON.parse(process.env.NODE_BOOTSTRAPERS)
}
else {
  var bootstrapers = ['/ip4/127.0.0.1/tcp/0']
}

// Setting up Node app
var app = express()
app.use(bp.json())
app.use(bp.urlencoded({ extended: true }))

const peerId = await peerIdFromString(peerIdString)

var providedResources = []

// Setting up the Libp2p node
const node = await createLibp2p({
  // peerId: peerId,
  addresses: {
    listen: [listen_address]
  },
  transports: [new TCP(), new WebSockets()],
  streamMuxers: [new Mplex()],
  connectionEncryption: [new Noise()],
  dht: new KadDHT(),
  peerDiscovery: [
    new Bootstrap({
      interval: 60e3,
      list: bootstrapers
    }),
    new MulticastDNS({
      interval: 20e3
    })
  ],
  connectionManager: {
    autoDial: true
  },
  pubsub: new FloodSub()
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

  const bytes = json.encode({ resource: resource })
  const hash = await sha256.digest(bytes)
  const cid = CID.create(1, json.code, hash)
  var providers = []
  try {
    providers = await all(node.contentRouting.findProviders(cid, { timeout: 3000 }))
  }
  catch(err) {
    await node.contentRouting.provide(cid)
    providedResources.push(resource)
    console.log(`Provided policy for resource ${resource}`)
    console.log(`Syncing with other providers for ${resource}...`)
    const providers = await all(node.contentRouting.findProviders(cid, { timeout: 3000 }))
    for (const provider of providers) {
      console.log(provider.multiaddrs[0].nodeAddress())
      await axios({
        method: 'get',
        url: `http://${provider.multiaddrs[0].nodeAddress().address}:8085/v1/policies?resource=${resource}`,
        headers: {
          'fiware-Service': service,
          'fiware-Servicepath': servicepath
        }
      })
      .then(async function (response) {
        console.log(response.data)
        for (const policy_entry of response.data) {
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
            console.log(err.response.data);
          })
        }
      })
      .catch(function (error) {
        console.log(error);
      })
    }
  }

  const topics = await node.pubsub.getTopics()
  if (!topics.includes(resource)) {
    await node.pubsub.subscribe(resource)
    console.log(`Subscribed to ${resource}`)
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

  const topics = await node.pubsub.getTopics()
  if (!topics.includes(resource)) {
    await node.pubsub.subscribe(resource)
    console.log(`Subscribed to ${resource}`)
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

  const topics = await node.pubsub.getTopics()
  if (!topics.includes(resource)) {
    await node.pubsub.subscribe(resource)
    console.log(`Subscribed to ${resource}`)
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
  console.log(`Node received: ${uint8ArrayToString(evt.detail.data)} on topic ${evt.detail.topic} from ${sender[0].multiaddr.nodeAddress().address}`)
  await axios({
    method: 'get',
    url: `http://${sender[0].multiaddr.nodeAddress().address}:8085/v1/policies/${message.policy_id}`,
    headers: {
      'fiware-Service': message.service,
      'fiware-Servicepath': message.servicepath
    }
  })
  .then(function (response) {
    console.log(response.data)
    if(message.action == "post") {
      axios({
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
      axios({
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
    if(message.action == "delete") {
      axios({
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
