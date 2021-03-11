DOMAINS:=*.oreore.net *.lo.oreore.net *.localhost.oreore.net
LEGO_SERVER_STG=https://acme-staging-v02.api.letsencrypt.org/directory
LEGO_SERVER_PRD=https://acme-v02.api.letsencrypt.org/directory
LEGO_SERVER:=$(shell lego --help| grep -- --server | perl -pe 's/.*default: "//;s/".*//')
#LEGO_SERVER:=$(LEGO_SERVER_STG)

DOMAIN_PATH=$(subst *,_,$(firstword $(DOMAINS)))
LEGO_SERVER_HOST=$(subst /directory,,$(subst https://,,$(LEGO_SERVER)))

all: all.pem all.pem.json lego_run_check

clean: FORCE
	rm -rf *.pem *.crt *.key *.pem.json certificates/

FORCE:
.PHONY: all clean FORCE

symlink: key.pem crt.pem all.pem all.pem.json
	@# サイト上からファイルを取得しやすくする為のショートハンド
	ln -sfn .lego/certificates/$(DOMAIN_PATH).all.pem      all.pem
	ln -sfn .lego/certificates/$(DOMAIN_PATH).all.pem.json all.pem.json

.PRECIOUS: all.pem all.pem.json key.pem crt.pem
all.pem: key.pem crt.pem
	cat crt.pem key.pem > $@
all.pem.json: key.pem crt.pem
	jq -n --rawfile cert crt.pem --rawfile key key.pem '{$$cert,$$key}' > $@
key.pem: .lego/certificates/$(DOMAIN_PATH).key
	ln -sfn .lego/certificates/$(DOMAIN_PATH).key key.pem
crt.pem: .lego/certificates/$(DOMAIN_PATH).crt
	ln -sfn .lego/certificates/$(DOMAIN_PATH).crt crt.pem

.PRECIOUS: .lego/certificates/%.key .lego/certificates/%.crt
.lego/certificates/%.key .lego/certificates/%.crt: lego_run_check
	@:

lego_run_check: FORCE
	@# 5184000 = 60 days
	@# 6912000 = 80 days
	@# 7776000 = 90 days
	openssl x509 -checkend 6912000 -noout < .lego/certificates/$(DOMAIN_PATH).crt || make lego_run

lego_run: FORCE
	make .lego/accounts/$(LEGO_SERVER_HOST)/$(LEGO_ACCOUNT)/account.json
	docker run \
		-e CLOUDFLARE_DNS_API_TOKEN="$(CLOUDFLARE_DNS_API_TOKEN)" \
		-v "$(PWD)/.lego:/.lego" \
		goacme/lego \
		--dns cloudflare \
		--server $(LEGO_SERVER) \
		$(patsubst %,--domains %, $(DOMAINS)) \
		--email "$(LEGO_ACCOUNT)" \
		--accept-tos \
		run

.PRECIOUS: .lego/accounts/%/account.json
.lego/accounts/%/account.json:
	echo "$(LEGO_ACCOUNTS_TGZ)" | openssl enc -A -d -base64 | tar xz

.PHONY: filename_aliases
filename_aliases:
	mkdir -p certificates
	# ドメイン名+ファイル種類(拡張子)　…複数ドメインの証明書があっても一つのディレクトリで管理出来る点が便利。ただし拡張子keyは他の用途でも使われておりダブルクリックした時の挙動が安定しないので星-1です。星4。
	ln -sfn ../.lego/certificates/$(DOMAIN_PATH).crt certificates/
	ln -sfn ../.lego/certificates/$(DOMAIN_PATH).key certificates/
	# ドメイン名+ファイル種類(拡張子)+フォーマット　……複数ドメインの証明書があっても一つのディレクトリで管理出来る点が便利。拡張子pemは種類はPEMフォーマットを表すだけだがPEMとして読めば種類は中身で分かるので問題になることが少ない。星5。
	ln -sfn $(DOMAIN_PATH).crt certificates/$(DOMAIN_PATH).crt.pem
	ln -sfn $(DOMAIN_PATH).key certificates/$(DOMAIN_PATH).key.pem
	# ファイル種類(拡張子)+フォーマット　シンプルで嫌いじゃない。星4。
	ln -sfn $(DOMAIN_PATH).crt certificates/crt.pem
	ln -sfn $(DOMAIN_PATH).key certificates/key.pem
	# ファイル種類(名前)+フォーマット　…シンプルで嫌いじゃない。星4。
	ln -sfn $(DOMAIN_PATH).crt certificates/cert.pem
	ln -sfn $(DOMAIN_PATH).key certificates/pkey.pem
	# ファイル種類(名前)+ファイル種類(拡張子)　…やや冗長。key拡張子の問題もある。星3。
	ln -sfn $(DOMAIN_PATH).crt certificates/cert.crt
	ln -sfn $(DOMAIN_PATH).key certificates/pkey.key
	# ファイル種類(名前)+ファイル種類(拡張子)+フォーマット　……冗長。key拡張子の問題は無くなるが長くなったせいか更に冗長度が増した感があり好きじゃない。星2。
	ln -sfn $(DOMAIN_PATH).crt certificates/cert.crt.pem
	ln -sfn $(DOMAIN_PATH).key certificates/pkey.key.pem
	# ファイル種類(証明書関連)+ファイル種類(拡張子)　…cert.crtとセットで扱うことで、certは証明書ファイル関連ファイルのprefixでこれはその秘密鍵ファイルだと分かる名前。組み合わせとしては嫌いじゃないがkey拡張子問題もある。星2。
	ln -sfn $(DOMAIN_PATH).key certificates/cert.key
	# ファイル種類(証明書関連)+ファイル種類(拡張子)　…cert.crt.pemとセットで扱うことで、証明書の秘密鍵だと分かる名前。組み合わせてとしては嫌いじゃない。星4。
	ln -sfn $(DOMAIN_PATH).key certificates/cert.key.pem
	# 証明書用途+ファイル種類(拡張子)　…証明書用途を含むことでクライアント証明書との区別しやすい点は良いが、key拡張子の問題もあり。星4。
	ln -sfn $(DOMAIN_PATH).crt certificates/server.crt
	ln -sfn $(DOMAIN_PATH).key certificates/server.key
	# ファイル種類(名前)+ファイル種類(拡張子)+フォーマット　……証明書用途を含むことでクライアント証明書と区別しやすい点が良い。最後の拡張子をpemにすることでkey拡張子の曖昧さの問題も無いのも良い。星5。
	ln -sfn $(DOMAIN_PATH).crt certificates/server.crt.pem
	ln -sfn $(DOMAIN_PATH).key certificates/server.key.pem
	# ドメイン名+ファイル種類(全部入り)+フォーマット　…証明書と秘密鍵を合体したPEMファイル。証明書と秘密鍵の取得が1トランザクションで取得出来る為、鍵と証明書の組み合わせが一致しないという心配が無い点でとても実用的。またこの合体形式のファイルを扱えるアプリやライブラリは結構多いので普通に単体で便利に使える点が楽で好き。crt.pem, key.pem とセットでの提供ならば文句なく星5の逸材。ただしこれ単体提だけだと分離必須なアプリに食わせるのが若干面倒なので単体評価は星4。
	ln -sfn ../.lego/certificates/$(DOMAIN_PATH).all.pem certificates/
	# ドメイン名+ファイル種類(全部入り)+フォーマット　…証明書と秘密鍵を{cert,key}という形に合体したJSONファイル。取得が1トランザクションで済む点で優秀。jqなどで証明書と秘密鍵の個別取り出しもしやすい点も強い。Nodeのhttps.createServerにオプションとしてそのまま渡せる点で便利だが、jsonというファイル名からだけでは中の構造が確実にそうなっているという保証が無い点でちょい汎用性にかけるので。星4。
	ln -sfn ../.lego/certificates/$(DOMAIN_PATH).key certificates/
	# ファイル種類(名前)+ファイル種類(全部入り)+フォーマット　…単体で使えて便利だが cert.crt.key, cert.crt.key と合わさるとやはり冗長感がで出るため便利さで+1、冗長さで-1、で総合評価は星3。
	ln -sfn $(DOMAIN_PATH).all.pem certificates/cert.all.pem
	# 証明書用途+ファイル種類(全部入り)+フォーマット　…証明書用途のファイル全部入りと分かりやすい。server.crt.pem, server.key.pem とのセット提供なら星5の利便性。単体評価は星4。
	ln -sfn $(DOMAIN_PATH).all.pem certificates/server.all.pem
	# 証明書用途+フォーマット  …{cert, key}という構造の全部入りJSONファイル。Nodeのhttps.createServerにオプションとしてそのまま渡せる点で便利。他言語を考えると汎用性はちょい下がる星3。
	ln -sfn $(DOMAIN_PATH).all.pem certificates/server.all.pem.json
	# 証明書用途+フォーマット  …証明書用途を含めることでクライアント証明書と区別しやすく、ファイル種類を表す文字列を入れないことで暗に全部入りを匂わせる高度な手法。ただし .pem をフォーマットではなく証明書専用の拡張子だと誤解を招く事もあり星4。
	ln -sfn $(DOMAIN_PATH).all.pem certificates/server.pem
	# ファイル種類(全部入り)+フォーマット  …シンプルな上に１ファイルで完結して便利。証明書と秘密鍵を単純に連結した形のPEM。証明書と秘密鍵のペアを1トランザクションで取得できるので組み合わせ不一致の考慮が不要というメリットは大きい。でも分離を要求するアプリだとちょい不便なので単体提供なら星4。cer,keyとのセット提供なら星5の逸材。
	ln -sfn $(DOMAIN_PATH).all.pem certificates/all.pem
	# ファイル種類(全部入り)+フォーマット  …シンプルな上に１ファイルで完結して便利。証明書と秘密鍵PEMを{cert,key}という構造のJSONにしたもの。Nodeのhttps.createServerに直接渡せて便利。証明書と秘密鍵を個別に必要ならjqなどで簡単に扱いやすい。但しファイル名だけをみてJSON構造に確信が持てるわけじゃない点がイマイチ。便利だがほかファイルとセット提供があると嬉しいが単体体評価なら星3。他とセットで提供されてると嬉しい存在。
	ln -sfn $(DOMAIN_PATH).all.pem.json certificates/all.pem.json
	# all.json とか server.json とかは流石に色々略しすぎてて証明書ファイル名としては適切じゃないと思うので作らない

.PHONY: publish_certificate
publish_certificate:
	git commit -m "Update certificate" all.pem all.pem.json .lego/certificates/_.oreore.net.* && SSH_AUTH_SOCK=$(shell ls /tmp/com.apple.launchd.*/Listeners | head -n1) git push
