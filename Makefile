DOMAIN_NAME="oreore.net"

all:
	@make .lego/certificates/_.$(DOMAIN_NAME).allin.pem
	ln -sfn .lego/certificates/_.oreore.net.allin.pem cert.allin.pem
	ln -sfn .lego/certificates/_.oreore.net.crt cert.crt
	ln -sfn .lego/certificates/_.oreore.net.crt cert.crt.pem
	ln -sfn .lego/certificates/_.oreore.net.crt cert.pem
	ln -sfn .lego/certificates/_.oreore.net.key cert.key
	ln -sfn .lego/certificates/_.oreore.net.key cert.key.pem
	ln -sfn .lego/certificates/_.oreore.net.key key.pem

.PRECIOUS: .lego/certificates/%.allin.pem .lego/certificates/%.key .lego/certificates/%.crt
.lego/certificates/%.allin.pem: .lego/certificates/%.key .lego/certificates/%.crt
	cat "$(@D)/$*.crt" "$(@D)/$*.key" > "$(@D)/$*.allin.pem"
.lego/certificates/%.crt .lego/certificates/%.key: lego_run
	@make lego_run

lego_accounts:
	echo "$(LEGO_ACCOUNTS_TGZ)" | openssl enc -A -d -base64 | tar xz

lego_renew: lego_accounts
	docker run \
		-e CLOUDFLARE_DNS_API_TOKEN="$(CLOUDFLARE_DNS_API_TOKEN)" \
		-v "$(PWD)/.lego:/.lego" \
		goacme/lego \
		--dns cloudflare \
		--domains "*.$(DOMAIN_NAME)" \
		--domains "*.lo.$(DOMAIN_NAME)" \
		--domains "*.localhost.$(DOMAIN_NAME)" \
		--email "$(LEGO_ACCOUNT)" \
		--accept-tos \
		run

