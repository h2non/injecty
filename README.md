# injecty [![Build Status](https://secure.travis-ci.org/h2non/injecty.png?branch=master)][travis] [![NPM version](https://badge.fury.io/js/injecty.png)][npm]

**injecty** is a micro library for **dependency injection and inversion of control container in JavaScript**.
It's dependency-free, light and small (~200 SLOC).
It was designed to be embedded in frameworks or libraries

It's intimately inspired in [AngularJS DI](https://docs.angularjs.org/guide/di) and provides useful features such as autodiscover injections from arguments using pattern matching, creating multiple containers with inheritance support between them, AngularJS-style injections based on array notation and more

injecty is written in [Wisp][wisp], a Clojure-like language which transpiles into plain JavaScript.
It exploits functional programming common patterns such as lambda lifting, pure functions, higher-order functions, function composition and more

## Installation

#### Node.js

```bash
npm install injecty
```

#### Browser

Via [Bower](http://bower.io)
```bash
bower install injecty
```

Via [Component](http://component.io)
```bash
component install injecty
```

Or loading the script remotely
```html
<script src="//cdn.rawgit.com/h2non/injecty/0.1.3/injecty.js"></script>
```

### Environments

It [works](http://kangax.github.io/compat-table/es5/) in any ES5 compliant engine

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
injecty.register('Request', XMLHttpRequest)
injecty.register('Log', console.log.bind(console))

function get(Request) {
  return function (url, cb) {
    var xhr = new Request()
    xhr.open('GET', url)
    xhr.onload = function () {
      if (xhr.readyState === 4) {
        cb(xhr.responseText)
      }
    }
    xhr.send()
    return xhr
  }
}

var get = injecty.invoke(get)
get('/test/sample.json', injecty.invoke(function (Log) {
  return Log // -> output body response
}))
```

## API

#### injecty.container([parent])

Creates a new container.
Optionally it can inherit from another container

```js
// register a dependency in the global built-in container
injecty.register('Math', Math)
// creates new container which inherits from global
var container = injecty.container(injecty)
// check it was registered
container.injectable('Math') // -> true
```

#### injecty.get(name)
Alias: `require`

Retrieve a registered dependency by its name

```js
injecty.get('Math') // -> {MathConstructor...}
```

#### injecty.register(name, value)
Alias: `set`

Register a new dependency in the container

```js
injecty.register('Location', window.location)
injecty.injectable('Location') // -> true
```

You can also register functions that require injections
```js
injecty.register('Date', Date)
injecty.register('now', injecty.inject(function (Date) {
  return new Date().getTime()
}))
var time = injecty.invoke(function (now) {
  return now()
})
console.log(time) // -> 1405170246959
```

##### Different ways to declare injections for consistency in browsers

Using the injection array notation
```js
injecty.register('random', ['Math', function (m) {
  return m.random()
}])
```

Setting the `$inject` property in the function object
```js
function random(m) {
  return m.random()
}
random.$inject = ['Math']
injecty.register('random', random)
```

#### injecty.invoke(fn/array)

Invoke a function injecting requested dependencies.
Optinally you can supply the arguments to inject as array notation

```js
var time = injecty.invoke(function (Date) {
  return new Date().getTime()
})
console.log(time) // -> 1405170246959
```

Using the array injection notation, useful for minification
```js
var time = injecty.invoke(['Date', function (D) {
  return new D().getTime()
}])
console.log(time) // -> 1405170246959
```

#### injecty.inject(fn/array)

Inject dependencies and return the partial function

```js
var time = injecty.inject(['Date', function (D) {
  return new D().getTime()
}])
```

#### injecty.annotate(fn/array)

Returns an array of names which the given function is requesting for injection

```js
var injectables = injecty.annotate(function (Math, Date) {
  ...
})
console.log(injectables) // -> ['Math', 'Date']
```

```js
function fn(m, d) {
  ...
}
fn.$inject = ['Math', 'Date']
var injectables = injecty.annotate(fn)
console.log(injectables) // -> ['Math', 'Date']
```

#### injecty.injectable(name)

Checks if a dependency was already registered and it's available to be injected

#### injecty.satisfies(fn)

Checks if can safisty all the requested dependecies to inject

```js
inject.register('Math', Math)
inject.register('Date', Date)
inject.safisfies(function (Math, Date) {}) // -> true
```

#### injecty.remove(name)

Remove a registered dependency from the container

```js
injecty.remove('Math').injectable('Math') // -> false
```

#### injecty.flush(name)

Flush all the registered dependencies in the container

```js
injecty.flush().injectable('Math') // -> false
```

## Contributing

Wanna help? Cool! It will be appreciated :)

You must add new test cases for any new feature or refactor you do,
always following the same design/code patterns that already exist

Tests specs are completely written in Wisp language.
Take a look to the language [documentation][wisp] if you are new with it.
You should follow the Wisp language coding conventions

### Development

Only [node.js](http://nodejs.org) is required for development

Clone this repository
```
$ git clone https://github.com/h2non/injecty.git && cd injecty
```

Install dependencies
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

## License

[MIT](http://opensource.org/licenses/MIT) - Tomas Aparicio

[wisp]: https://github.com/Gozala/wisp
[travis]: http://travis-ci.org/h2non/injecty
[npm]: http://npmjs.org/package/injecty
