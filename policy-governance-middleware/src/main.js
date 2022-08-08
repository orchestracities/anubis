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

// Configuration for the port used by this node
const server_port = process.env.SERVER_PORT || 8099

// Setting up Node app
var app = express()
app.use(bp.json())
app.use(bp.urlencoded({ extended: true }))

// Setting up the Libp2p node
const node = await createLibp2p({
  addresses: {
    listen: ['/ip4/127.0.0.1/tcp/0']
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
  pubsub: new FloodSub()
})

// Endpoint when a new policy is created
app.post('/resource/policy/new', async(req, res) => {
  if (!Object.keys(req.body).length) {
   return res.status(400).json({
     message: "Request body cannot be empty",
   })
  }
  var { resource, policy } = req.body
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

  const bytes = json.encode({ resource: resource })
  const hash = await sha256.digest(bytes)
  const cid = CID.create(1, json.code, hash)
  try {
    await node.contentRouting.provide(cid)
  }
  catch(err) {
    console.log(`No other peers to provide ${resource} to`)
  }
  console.log(`Provided policy for resource ${resource}`)
  try {
    console.log(`Syncing with other providers for ${resource}...`)
    const providers = await all(node.contentRouting.findProviders(cid, { timeout: 3000 }))
    for (const provider of providers) {
      console.log(provider.multiaddrs[0].nodeAddress())
      await axios({
        method: 'get',
        url: `http://${provider.multiaddrs[0].nodeAddress().address}:8085/v1/policies?resource=${resource}`,
        headers: {
          'fiware-Service': 'Tenant1',
          'fiware-Servicepath': '/'
        }
      })
      .then(function (response) {
        console.log(response.data)
        for (const policy_entry of response.data) {
          axios({
            method: 'post',
            url: `http://${provider.multiaddrs[0].nodeAddress().address}:8085/v1/policies?resource=${resource}`,
            headers: {
              'fiware-Service': 'Tenant1',
              'fiware-Servicepath': '/'
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
  catch(err) {
    console.log(`No other providers for ${resource}`)
  }

  // TODO: Check if already subscribed
  await node.pubsub.subscribe(resource)
  console.log(`Subscribed to ${resource}`)
  await node.pubsub.publish(resource, uint8ArrayFromString(policy)).catch(err => {
    console.error(err)
    res.end(`Error: ${err}`)
  })
  res.end("Policy message sent: " + policy)
})

// Function to process a message arriving on a topic (resource)
async function processTopicMessage(evt) {
  const sender = await node.peerStore.addressBook.get(evt.detail.from)
  console.log(`Node received: ${uint8ArrayToString(evt.detail.data)} on topic ${evt.detail.topic} from ${sender[0].multiaddr.nodeAddress().address}`)
  await axios({
    method: 'get',
    url: `http://${sender[0].multiaddr.nodeAddress().address}:8085/v1/policies?resource=${evt.detail.topic}`,
    headers: {
      'fiware-Service': 'Tenant1',
      'fiware-Servicepath': '/'
    }
  })
  .then(function (response) {
    console.log(response.data)
    for (const policy_entry of response.data) {
      axios({
        method: 'post',
        url: `http://${sender[0].multiaddr.nodeAddress().address}:8085/v1/policies?resource=${evt.detail.topic}`,
        headers: {
          'fiware-Service': 'Tenant1',
          'fiware-Servicepath': '/'
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

// Starting server
var server = app.listen(server_port, async() => {

  await node.start()

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
