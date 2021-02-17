DOMAIN_NAME="oreore.net"

.PHONY: all
all: 
	@make .lego/certificates/_.$(DOMAIN_NAME).all.pem
	@make .lego/certificates/_.$(DOMAIN_NAME).all.json
	@# ドメイン名+ファイル種類(拡張子)　…複数ドメインの証明書があっても一つのディレクトリで管理出来る点が便利。ただし拡張子keyは他の用途でも使われておりダブルクリックした時の挙動が安定しないので星-1です。星4。
	ln -sfn ../.lego/certificates/_.oreore.net.crt certificates/
	ln -sfn ../.lego/certificates/_.oreore.net.key certificates/
	@# ドメイン名+ファイル種類(拡張子)+フォーマット　……複数ドメインの証明書があっても一つのディレクトリで管理出来る点が便利。拡張子pemは種類はPEMフォーマットを表すだけだがPEMとして読めば種類は中身で分かるので問題になることが少ない。星5。
	ln -sfn _.oreore.net.crt certificates/_.oreore.net.crt.pem
	ln -sfn _.oreore.net.key certificates/_.oreore.net.key.pem
	@# ファイル種類(拡張子)+フォーマット　シンプルで嫌いじゃない。星4。
	ln -sfn _.oreore.net.crt certificates/crt.pem
	ln -sfn _.oreore.net.key certificates/key.pem
	@# ファイル種類(名前)+フォーマット　…シンプルで嫌いじゃない。星4。
	ln -sfn _.oreore.net.crt certificates/cert.pem
	ln -sfn _.oreore.net.key certificates/pkey.pem
	@# ファイル種類(名前)+ファイル種類(拡張子)　…やや冗長。key拡張子の問題もある。星3。
	ln -sfn _.oreore.net.crt certificates/cert.crt
	ln -sfn _.oreore.net.key certificates/pkey.key
	@# ファイル種類(名前)+ファイル種類(拡張子)+フォーマット　……冗長。key拡張子の問題は無くなるが長くなったせいか更に冗長度が増した感があり好きじゃない。星2。
	ln -sfn _.oreore.net.crt certificates/cert.crt.pem
	ln -sfn _.oreore.net.key certificates/pkey.key.pem
	@# ファイル種類(証明書関連)+ファイル種類(拡張子)　…cert.crtとセットで扱うことで、certは証明書ファイル関連ファイルのprefixでこれはその秘密鍵ファイルだと分かる名前。組み合わせとしては嫌いじゃないがkey拡張子問題もある。星2。
	ln -sfn _.oreore.net.key certificates/cert.key
	@# ファイル種類(証明書関連)+ファイル種類(拡張子)　…cert.crt.pemとセットで扱うことで、証明書の秘密鍵だと分かる名前。組み合わせてとしては嫌いじゃない。星4。
	ln -sfn _.oreore.net.key certificates/cert.key.pem
	@# 証明書用途+ファイル種類(拡張子)　…証明書用途を含むことでクライアント証明書との区別しやすい点は良いが、key拡張子の問題もあり。星4。
	ln -sfn _.oreore.net.crt certificates/server.crt
	ln -sfn _.oreore.net.key certificates/server.key
	@# ファイル種類(名前)+ファイル種類(拡張子)+フォーマット　……証明書用途を含むことでクライアント証明書と区別しやすい点が良い。最後の拡張子をpemにすることでkey拡張子の曖昧さの問題も無いのも良い。星5。
	ln -sfn _.oreore.net.crt certificates/server.crt.pem
	ln -sfn _.oreore.net.key certificates/server.key.pem
	@# ドメイン名+ファイル種類(全部入り)+フォーマット　…証明書と秘密鍵を合体したPEMファイル。証明書と秘密鍵の取得が1トランザクションで取得出来る為、鍵と証明書の組み合わせが一致しないという心配が無い点でとても実用的。またこの合体形式のファイルを扱えるアプリやライブラリは結構多いので普通に単体で便利に使える点が楽で好き。crt.pem, key.pem とセットでの提供ならば文句なく星5の逸材。ただしこれ単体提だけだと分離必須なアプリに食わせるのが若干面倒なので単体評価は星4。
	ln -sfn ../.lego/certificates/_.oreore.net.all.pem certificates/
	@# ドメイン名+ファイル種類(全部入り)+フォーマット　…証明書と秘密鍵を{cert,key}という形に合体したJSONファイル。取得が1トランザクションで済む点で優秀。jqなどで証明書と秘密鍵の個別取り出しもしやすい点も強い。Nodeのhttps.createServerにオプションとしてそのまま渡せる点で便利だが、jsonというファイル名からだけでは中の構造が確実にそうなっているという保証が無い点でちょい汎用性にかけるので。星4。
	ln -sfn ../.lego/certificates/_.oreore.net.key certificates/
	@# ファイル種類(名前)+ファイル種類(全部入り)+フォーマット　…単体で使えて便利だが cert.crt.key, cert.crt.key と合わさるとやはり冗長感がで出るため便利さで+1、冗長さで-1、で総合評価は星3。
	ln -sfn _.oreore.net.all.pem certificates/cert.all.pem
	@# 証明書用途+ファイル種類(全部入り)+フォーマット　…証明書用途のファイル全部入りと分かりやすい。server.crt.pem, server.key.pem とのセット提供なら星5の利便性。単体評価は星4。
	ln -sfn _.oreore.net.all.pem certificates/server.all.pem
	@# 証明書用途+フォーマット  …{cert, key}という構造の全部入りJSONファイル。Nodeのhttps.createServerにオプションとしてそのまま渡せる点で便利。他言語を考えると汎用性はちょい下がる星3。
	ln -sfn _.oreore.net.all.pem certificates/server.all.pem.json
	@# 証明書用途+フォーマット  …証明書用途を含めることでクライアント証明書と区別しやすく、ファイル種類を表す文字列を入れないことで暗に全部入りを匂わせる高度な手法。ただし .pem をフォーマットではなく証明書専用の拡張子だと誤解を招く事もあり星4。
	ln -sfn _.oreore.net.all.pem certificates/server.pem
	@# ファイル種類(全部入り)+フォーマット  …シンプルな上にファイル１個で完結するので結構好き。証明書と秘密鍵の取得が1トランザクションが済むのはそれらの組み合わせ不一致を考慮する必要が無い点は強い。でも分離を要求するアプリで不便な点もあり、単体では星4。
	ln -sfn _.oreore.net.all.pem certificates/all.pem
	@# ファイル種類(全部入り)+フォーマット  …シンプルな上にファイル１個で完結しNodeのhttps.createServerに直接渡せる点で便利。ターゲットを限定しすぎてる感もあり星3。
	ln -sfn _.oreore.net.all.pem certificates/all.pem.json
	@# 以下はサイト上からファイルを取得しやすくする為のショートハンド
	ln -sfn certificates/_.oreore.net.crt
	ln -sfn certificates/_.oreore.net.key
	ln -sfn certificates/_.oreore.net.crt.pem
	ln -sfn certificates/_.oreore.net.key.pem
	ln -sfn certificates/_.oreore.net.all.pem
	ln -sfn certificates/_.oreore.net.all.json
	ln -sfn certificates/crt.pem
	ln -sfn certificates/key.pem
	ln -sfn certificates/cert.crt
	ln -sfn certificates/pkey.key
	ln -sfn certificates/cert.crt.pem
	ln -sfn certificates/pkey.key.pem
	ln -sfn certificates/cert.all.pem
	ln -sfn certificates/cert.pem
	ln -sfn certificates/pkey.pem
	ln -sfn certificates/server.crt
	ln -sfn certificates/server.key
	ln -sfn certificates/server.pem
	ln -sfn certificates/server.crt.pem
	ln -sfn certificates/server.key.pem
	ln -sfn certificates/server.all.pem
	ln -sfn certificates/server.all.pem.json
	ln -sfn certificates/all.pem
	ln -sfn certificates/all.pem.json
	# all.json とか server.json とかは流石に色々略しすぎてて証明書ファイル名としては適切じゃないと思うので作らない


.PRECIOUS: .lego/certificates/%.all.pem .lego/certificates/%.all.json
.lego/certificates/%.all.pem: .lego/certificates/%.key .lego/certificates/%.crt
	cat "$(@D)/$*.crt" "$(@D)/$*.key" > "$(@D)/$*.all.pem"
.lego/certificates/%.all.json: .lego/certificates/%.key .lego/certificates/%.crt
	jq -n --rawfile cert "$(@D)/$*.crt" --rawfile key "$(@D)/$*.key" '{$cert,$key}' > "$(@D)/$*.all.pem"

.PRECIOUS: .lego/certificates/%.key .lego/certificates/%.crt
.lego/certificates/%.crt .lego/certificates/%.key: lego_run

.PHONY: lego_run
lego_run: lego_accounts
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

.PHONY: lego_accounts
lego_accounts: .lego/accounts/*/*/account.json
	if test -n "$(LEGO_ACCOUNTS_TGZ)"; then echo "$(LEGO_ACCOUNTS_TGZ)" | openssl enc -A -d -base64 | tar xz; fi
