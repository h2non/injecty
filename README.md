# injecty [![Build Status](https://secure.travis-ci.org/h2non/injecty.png?branch=master)][travis] [![NPM version](https://badge.fury.io/js/injecty.png)][npm]

**injecty** is a micro **dependency injection container for JavaScript**

It was intimately inspired in [AngularJS DI](https://docs.angularjs.org/guide/di) and supports useful features such as injections discovery arguments using pattern matching and multiple containers with inheritance

injecty is written in [Wisp][wisp], a Clojure-like language which transpiles into plain JavaScript.
It exploits functional programming common patterns such as lambda lifting, pure functions, higher-order functions, function composition and more

## Installation

#### Node.js

```bash
npm install injecty --save
```

#### Browser

Via Bower package manager
```bash
bower install injecty --save
```

Or loading the script remotely (just for testing or development)
```html
<script src="//rawgithub.com/h2non/injecty/master/injecty.js"></script>
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
var injecty = require('injecty')
```

```js
funciton Type(gender) {
  return {
    gender: gender
  }
}

function HumanFactory(Type) {
  return new Human(Type)
}

injecty.register('Type', Type)
var human = injecty.inject(HumanFactory)
```

## API

#### injecty.container(parent)
Returns: `Container`

Creates a new container

```js
var diContainer = injecty.container()
```

#### injecty.get(name)
Alias: `require`

Retrieve a registered dependency by its name

#### injecty.register(name, value)
Alias: `set`

#### injecty.invoke([fn|array])

Invoke a function, optinally you can supply the arguments to inject as array notation

#### injecty.inject([fn|array])

Inject dependencies to a current function

#### injecty.annotate([fn|array])

Returns an array of names which the given function is requesting for injection

#### injecty.injectable(name)

Checks if a dependency was registered and is available to be injectyect

#### injecty.remove(name)

Remove a registered dependency from the container

#### injecty.flush(name)

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
$ git clone https://github.com/h2non/injecty.git && cd injecty
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
[travis]: http://travis-ci.org/h2non/injecty
[npm]: http://npmjs.org/package/injecty
