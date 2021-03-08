#!/usr/bin/env node
import https from 'https'

Promise.all([
  new Promise((ok,ng,_='')=>https.request('https://oreore.net/key.pem',res=>res.on('data',d=>_+=d).on('end',()=>ok(_))).on('error',ng).end()),
  new Promise((ok,ng,_='')=>https.request('https://oreore.net/crt.pem',res=>res.on('data',d=>_+=d).on('end',()=>ok(_))).on('error',ng).end()),
])
  .then(([key,cert])=>new Promise((ok,ng)=>{
    const port = process.argv[2] ?? 8443;
    https.createServer({key, cert}, (req, res) => {
      res.setHeader('Content-Type', 'application/json')
      res.end(JSON.stringify({req:{
        ...["method", "url", "httpVersion", "headers"].reduce((o,k)=>Object.assign(o, {[k]:req[k]}), {}),
        ...{socket:['servername','alpnProtocol'].reduce((o,k)=>Object.assign(o, {[k]:req.socket[k]}), {})},
      }}))
    })
      .on('error', ng)
      .on('close', ok)
      .on('listening', ()=>['localhost','sub.localhost','lo','sub.lo','sub','127-0-0-1.ip', 'sub-127-0-0-1.ip'].map(s=>console.log(`https://${s}.oreore.net:${port}`)))
      .listen(port)
  }))
  .then(r=>console.log(r))
  .catch(e=>console.error(e))
