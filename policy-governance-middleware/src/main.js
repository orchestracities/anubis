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

const server_port = process.env.SERVER_PORT || 8099
const other_node = process.env.OTHER_NODE || '/ip4/127.0.0.1/tcp/0'

var app = express()
app.use(bp.json())
app.use(bp.urlencoded({ extended: true }))

const bootstrapMultiaddrs = [
  other_node
]

const node = await createLibp2p({
  addresses: {
    listen: ['/ip4/127.0.0.1/tcp/0']
  },
  transports: [new TCP(), new WebSockets()],
  streamMuxers: [new Mplex()],
  connectionEncryption: [new Noise()],
  dht: new KadDHT(),
  peerDiscovery: [
    new Bootstrap({
      list: bootstrapMultiaddrs,
      interval: 2000
    })
  ],
  connectionManager: {
    autoDial: true
  },
  //pubsub: new FloodSub({emitSelf: true})
  pubsub: new FloodSub()
})

app.post('/resource', async(req, res) => {
  if (!Object.keys(req.body).length) {
   return res.status(400).json({
     message: "Request body cannot be empty",
   })
  }
  var { resource } = req.body
  if (!resource) {
   res.status(400).json({
     message: "Ensure you sent a resource field",
   })
  }
  const bytes = json.encode({ resource: resource })
  const hash = await sha256.digest(bytes)
  const cid = CID.create(1, json.code, hash)
  await node.contentRouting.provide(cid)
  console.log(`Provided ${resource}`)
  await node.pubsub.subscribe(resource)
  console.log(`Subscribed to ${resource}`)
  // TODO: Find other providers, get policies
  res.end("Posted resource " + resource)
})

app.get('/resource/:id', async(req, res) => {
  const bytes = json.encode({ resource: req.params.id })
  const hash = await sha256.digest(bytes)
  const cid = CID.create(1, json.code, hash)

  try {
    const providers = await all(node.contentRouting.findProviders(cid, { timeout: 3000 }))
    console.log('Found providers:', providers)
    res.end("Found providers: " + providers)
  }
  catch(err) {
    console.log("No providers found")
    res.end("No providers found")
  }
})

app.post('/resource/:id/policy', async(req, res) => {
  if (!Object.keys(req.body).length) {
   return res.status(400).json({
     message: "Request body cannot be empty",
   })
  }
  var { policy } = req.body
  if (!policy) {
   res.status(400).json({
     message: "Ensure you sent a policy field",
   })
  }
  await node.pubsub.subscribe(req.params.id)
  await node.pubsub.publish(req.params.id, uint8ArrayFromString(policy)).catch(err => {
    console.error(err)
    res.end(`Error: ${err}`)
  })
  res.end("Policy message sent: " + policy)
})

async function processTopicMessage(evt) {
  console.log(`Node received: ${uint8ArrayToString(evt.detail.data)} on topic ${evt.detail.topic}`)
  try {
    const bytes = json.encode({ resource: evt.detail.topic })
    const hash = await sha256.digest(bytes)
    const cid = CID.create(1, json.code, hash)
    const providers = await all(node.contentRouting.findProviders(cid, { timeout: 3000 }))
    console.log('Found providers:', providers)
  }
  catch(err) {
    console.log("No providers found")
  }
  // TODO: Get resource policies from content providers
}

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
