# inj [![Build Status](https://secure.travis-ci.org/h2non/inj.png?branch=master)][travis] [![NPM version](https://badge.fury.io/js/inj.png)][npm]

**inj** is a tiny **dependency injection container library for JavaScript environments**. It was intimately inspired in [AngularJS DI](https://docs.angularjs.org/guide/di)

It support automatic dependency based on arguments pattern matching and more useful features

inj is written in [Wisp][wisp], a Clojure-like language which transpiles into plain JavaScript.
It exploits functional programming common patterns such as lambda lifting, pure functions, higher-order functions, function composition and more

## Installation

#### Node.js

```bash
npm install inj --save
```

#### Browser

Via Bower package manager
```bash
bower install inj --save
```

Or loading the script remotely (just for testing or development)
```html
<script src="//rawgithub.com/h2non/inj/master/inj.js"></script>
```

### Environments

It [works](http://kangax.github.io/compat-table/es5/) properly in any ES5 compliant engine

- Node.js
- Chrome >= 5
- Firefox >= 3
- Safari >= 5
- Opera >= 12
- IE >= 9

## Basic usage

```js
var inj = require('inj')
```

```js
function Human(type, gender) {
  this.type = type
  this.gender = gender
}

inj.register('Human', Human)
var HumanFactory = inj.define(['dep1', 'dep2'], Human)
```

## API

Each

#### inj.container(parent)
Returns: `Container`

Creates a new container

```js
var diContainer = inj.container()
```

#### inj.get(name)

Retrieve a registered dependency by its name

#### inj.register(name, value)
Alias: `set`

#### inj.inject([fn|array])

Inject dependencies to a current function

#### inj.injectable(name)

Checks if a dependency was registered and is available to be inject

#### inj.remove(name)

Remove a registered dependency from the container

#### inj.flush(name)

Flush all the container registered dependencies

## Contributing

Wanna help? Cool! It will be appreciated :)

You must add new test cases for any new feature or refactor you do,
always following the same design/code patterns that already exist

Tests specs are completely written in Wisp language.
Take a look to the language [documentation][wisp] if you are new with it.
You should follow the Wisp language coding conventions

### Development

Only [node.js](http://nodejs.org) is required for development

Clone/fork this repository
```
$ git clone https://github.com/h2non/inj.git && cd inj
```

Install package dependencies
```
$ npm install
```

Compile code
```
$ make compile
```

Run tests
```
$ make test
```

Browser sources bundle generation
```
$ make browser
```

Release a new version
```
$ make release
```

## License

[MIT](http://opensource.org/licenses/MIT) - Tomas Aparicio

[wisp]: https://github.com/Gozala/wisp
[travis]: http://travis-ci.org/h2non/inj
[npm]: http://npmjs.org/package/inj
