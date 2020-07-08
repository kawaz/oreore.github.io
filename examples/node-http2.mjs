#!/usr/bin/env node
import http2 from 'http2'

Promise.all([
  new Promise((ok,ng,_='')=>http2.connect('https://oreore.net').request({':path':'/key.pem'}).on('data',d=>_+=d).on('end',()=>ok(_)).on('error',ng).end()),
  new Promise((ok,ng,_='')=>http2.connect('https://oreore.net').request({':path':'/cert.pem'}).on('data',d=>_+=d).on('end',()=>ok(_)).on('error',ng).end()),
])
  .then(([key,cert])=>new Promise((ok,ng)=>{
    const port = process.argv[2] ?? 8443;
    http2.createSecureServer({key, cert, allowHTTP1:true})
      .on('stream', (stream, headers) => {
        stream.respond({
          'content-type': 'application/json',
          ':status': 200,
        })
        stream.end(JSON.stringify({headers}))
      })
      .on('error', ng)
      .on('close', ok)
      .on('listening', ()=>['localhost','sub.localhost','lo','sub.lo','sub','127-0-0-1.ip', 'sub-127-0-0-1.ip'].map(s=>console.log(`https://${s}.oreore.net:${port}`)))
      .listen(port)
  }))
  .then(r=>console.log(r))
  .catch(e=>console.error(e))
