SHELL := /bin/bash

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

.PHONY: clean
clean:
	rm -rf log/* tmp/db .rocks
