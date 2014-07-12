BROWSERIFY = node ./node_modules/browserify/bin/cmd.js
WISP = ./node_modules/wisp/bin/wisp.js
WISP_MODULE = ./node_modules/wisp/
MOCHA = ./node_modules/.bin/mocha
UGLIFYJS = ./node_modules/.bin/uglifyjs
BANNER = "/*! inj.js - v0.1 - MIT License - https://github.com/h2non/inj */"

define release
	VERSION=`node -pe "require('./package.json').version"` && \
	NEXT_VERSION=`node -pe "require('semver').inc(\"$$VERSION\", '$(1)')"` && \
	node -e "\
		var j = require('./package.json');\
		j.version = \"$$NEXT_VERSION\";\
		var s = JSON.stringify(j, null, 2);\
		require('fs').writeFileSync('./package.json', s);" && \
	node -e "\
		var j = require('./bower.json');\
		j.version = \"$$NEXT_VERSION\";\
		var s = JSON.stringify(j, null, 2);\
		require('fs').writeFileSync('./bower.json', s);" && \
	git commit -am "release $$NEXT_VERSION" && \
	git tag "$$NEXT_VERSION" -m "Version $$NEXT_VERSION"
endef

define replace
	node -e "\
		var fs = require('fs'); \
		var os = require('os-shim'); \
		var str = fs.readFileSync('./inj.js').toString(); \
		str = str.split(os.EOL).map(function (line) { \
		  return line.replace(/^void 0;/, '') \
		}).filter(function (line) { \
		  return line.length \
		}) \
		.join(os. EOL) \
		.replace(/(var _ns_ = \{\n((.*)\n(.*)\n\s+\}\;(\n)?))+/g, '') \
		.replace(/(\{(\s+)?\n(\s+)?\}\n)/g, ''); \
		fs.writeFileSync('./inj.js', str)"
endef

default: all
all: test browser
browser: cleanbrowser test banner browserify replace uglify
test: compile mocha

mkdir:
	mkdir -p lib

compile: mkdir clean
	cat src/macros.wisp src/utils.wisp | $(WISP) --no-map > ./lib/utils.js
	cat src/macros.wisp src/container.wisp | $(WISP) --no-map > ./lib/container.js
	cat src/macros.wisp src/types.wisp | $(WISP) --no-map > ./lib/types.js
	cat src/macros.wisp src/inj.wisp | $(WISP) --no-map > ./lib/inj.js

banner:
	@echo $(BANNER) > inj.js

browserify:
	$(BROWSERIFY) \
		--exports require \
		--standalone inj \
		--entry ./lib/inj.js >> ./inj.js

replace:
	@$(call replace)

uglify:
	$(UGLIFYJS) inj.js --mangle --preamble $(BANNER) > inj.min.js

clean:
	rm -rf lib/*

cleanbrowser:
	rm -f *.js

mocha:
	$(MOCHA) --reporter spec --ui tdd --compilers wisp:$(WISP_MODULE)

loc:
	wc -l src/*

release:
	@$(call release, patch)

release-minor:
	@$(call release, minor)

publish: browser release
	git push --tags origin HEAD:master
	npm publish
