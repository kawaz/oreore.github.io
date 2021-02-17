# oreore.net
Free localhost certificate

# localhost for development
The following FQDNs return `127.0.0.1` or `::1`
- *.oreore.net
- *.lo.oreore.net
- *.localhost.oreore.net

# Free key and cert for *.oreore.net
- [key.pem](https://oreore.net/key.pem)
- [cert.pem](https://oreore.net/cert.pem)

# Usage

```
# Download key and cert
curl -sLO https://oreore.net/key.pem
curl -sLO https://oreore.net/cert.pem

# Launch web server
openssl s_server -key key.pem -cert cert.pem -www
```

Open [https://localhost.oreore.net:4433](https://localhost.oreore.net:4433)

# Screenshot
![screenshot-dialog-chrome.png](screenshot-dialog-chrome.png)
