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
      list: bootstrapMultiaddrs
    })
  ],
  connectionManager: {
    autoDial: true
  }
})

app.get('/policy/:id', async(req, res) => {
  const bytes = json.encode({ policy_id: req.params.id })
  const hash = await sha256.digest(bytes)
  const cid = CID.create(1, json.code, hash)

  try {
    const providers = await all(node.contentRouting.findProviders(cid, { timeout: 3000 }))
    console.log('Found provider:', providers[0].id.toString())
    res.end(providers[0].id.toString())
  }
  catch(err) {
    console.log("No providers found")
    res.end("No providers found")
  }
})

app.post('/policy', async(req, res) => {
  if (!Object.keys(req.body).length) {
   return res.status(400).json({
     message: "Request body cannot be empty",
   })
  }
  var { policy_id } = req.body
  if (!policy_id) {
   res.status(400).json({
     message: "Ensure you sent a policy_id field",
   })
  }
  const bytes = json.encode({ policy_id: policy_id })
  const hash = await sha256.digest(bytes)
  const cid = CID.create(1, json.code, hash)
  await node.contentRouting.provide(cid)
  res.end("Done")
})

async function providePolicies() {
  // TODO: Get policies from Anubis
  var policies = [{
      "policy_id": "foo"
    },
    {
      "policy_id": "bar"
    }
  ]
  for (const policy of policies) {
    const bytes = json.encode(policy)
    const hash = sha256.digest(bytes)
    const cid = CID.create(1, json.code, hash)

    try {
      const providers = await all(node.contentRouting.findProviders(cid, { timeout: 3000 }))
    }
    catch(err) {
      node.contentRouting.provide(cid)
    }
  }
}

var server = app.listen(server_port, async() => {

  await node.start()

  console.log("Node started with:")
  node.getMultiaddrs().forEach((ma) => console.log(`${ma.toString()}`))

  node.connectionManager.addEventListener('peer:connect', (evt) => {
    const connection = evt.detail
    console.log('Connection established to:', connection.remotePeer.toString())
  })

  node.addEventListener('peer:discovery', (evt) => {
    const peer = evt.detail
    if (node.peerId.toString() == peer.id.toString()) {
      return
    }
    console.log('Discovered:', peer.id.toString())
    node.peerStore.addressBook.set(peer.id, peer.multiaddrs)
    //node.dial(peer.id)
    providePolicies()
  })

  await delay(1000)

  console.log(node.peerId.toString())

  var host = server.address().address
  var port = server.address().port
  console.log("App listening at http://%s:%s", host, port)
})
