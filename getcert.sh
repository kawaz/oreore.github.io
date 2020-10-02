#!/bin/bash
cd "$(dirname "$0")" || exit 1

echo "$LEGO_ACCOUNTS_TGZ" | openssl enc -A -d -base64 | tar xz

docker run \
  -e CLOUDFLARE_DNS_API_TOKEN="$CLOUDFLARE_DNS_API_TOKEN" \
  -v "$PWD/.lego:/.lego" \
  goacme/lego \
  --dns cloudflare \
  --domains \*.oreore.net \
  --domains \*.localhost.oreore.net \
  --domains \*.lo.oreore.net \
  --email "$LEGO_ACCOUNT" \
  --accept-tos \
  run

