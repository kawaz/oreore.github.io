# oreore.net
Free localhost certificate

# localhost for development
The following FQDNs return `127.0.0.1` or `::1`
- *.oreore.net
- *.lo.oreore.net
- *.localhost.oreore.net

# Free key and cert for *.oreore.net
- [key.pem](https://oreore.net/key.pem)
- [crt.pem](https://oreore.net/crt.pem)
- key and certificate
  - [all.pem](https://oreore.net/all.pem)
  - [all.pem.json](https://oreore.net/all.pem.json)

# Usage

```
# Download key and cert
curl -sLO https://oreore.net/key.pem
curl -sLO https://oreore.net/crt.pem
# Launch web server
openssl s_server -key key.pem -cert crt.pem -www -accept 4433
```

Open [https://localhost.oreore.net:4433](https://localhost.oreore.net:4433)

# Screenshot
![screenshot-dialog-chrome.png](https://oreore.net/screenshot-dialog-chrome.png)
