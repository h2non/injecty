# injecty [![Build Status](https://secure.travis-ci.org/h2non/injecty.png?branch=master)][travis] [![NPM version](https://badge.fury.io/js/injecty.png)][npm]

**injecty** is a micro **dependency injection container for JavaScript environments**.

It was intimately inspired in [AngularJS DI](https://docs.angularjs.org/guide/di) and supports useful features such as automatic dependency discovery based on arguments pattern matching, multiple isolated or inherited containers and more

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

injecty.register('Human', HumanFactory)
var human = injecty.inject(Human)
```

## API

Each

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

#### injecty.inject([fn|array])

injectyect dependencies to a current function

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
