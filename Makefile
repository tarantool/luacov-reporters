SHELL = /bin/bash
# use gsed on macOs
SED := $(if $(shell which gsed 2> /dev/null), gsed, sed)

ROCK_NAME = luacov-reporters
ROCKS_UPLOAD_URL = https://$(ROCKS_USERNAME):$(ROCKS_PASSWORD)@rocks.tarantool.org

.rocks: Makefile luacov-reporters-scm-1.rockspec
	tarantoolctl rocks make
	tarantoolctl rocks install luatest 0.5.1
	tarantoolctl rocks install luacov 0.13.0
	tarantoolctl rocks install luacheck 0.25.0

.PHONY: lint
lint: .rocks
	.rocks/bin/luacheck ./

.PHONY: test
test: .rocks
	rm -f tmp/luacov.*
	.rocks/bin/luatest
# 	Don't try to use luacov here until they use it in luacov repo.
# 	luacov uses global configuration so it's impossible to run test reports
# 	while collecting coverage.
# 	.rocks/bin/luatest --coverage
# 	.rocks/bin/luacov -r summary .
# 	cat tmp/luacov.report.out

PHONY: release-scm
release-scm:
	curl --fail -X PUT -F rockspec=@$(ROCK_NAME)-scm-1.rockspec	$(ROCKS_UPLOAD_URL)

PHONY: release-tag
release-tag: build-tag
	curl --fail -X PUT -F rockspec=@release/$(ROCK_NAME)-$(TAG)-1.rockspec	$(ROCKS_UPLOAD_URL)
	curl --fail -X PUT -F rockspec=@release/$(ROCK_NAME)-$(TAG)-1.all.rock	$(ROCKS_UPLOAD_URL)

PHONY: build-tag
build-tag:
ifndef TAG
	$(error TAG is required)
endif

	echo "Building release \"$(TAG)\""
	mkdir -p release
	$(SED) -e "s/branch = '.\+'/tag = '$(TAG)'/g" \
		-e "s/version = '.\+'/version = '$(TAG)-1'/g" \
		$(ROCK_NAME)-scm-1.rockspec > release/$(ROCK_NAME)-$(TAG)-1.rockspec

	tarantoolctl rocks make release/$(ROCK_NAME)-$(TAG)-1.rockspec
	tarantoolctl rocks pack $(ROCK_NAME) $(TAG) && mv $(ROCK_NAME)-$(TAG)-1.all.rock release/

.PHONY: clean
clean:
	rm -rf log/* tmp/db .rocks
