/*! injecty.js - v0.1 - MIT License - https://github.com/h2non/injecty */
!function(e){if("object"==typeof exports&&"undefined"!=typeof module)module.exports=e();else if("function"==typeof define&&define.amd)define([],e);else{var f;"undefined"!=typeof window?f=window:"undefined"!=typeof global?f=global:"undefined"!=typeof self&&(f=self),f.injecty=e()}}(function(){var define,module,exports;return (function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(_dereq_,module,exports){
{
        var injecty_lib_types = _dereq_('./types');
    var newPool = injecty_lib_types.newPool;
    var injecty_lib_utils = _dereq_('./utils');
    var isFn = injecty_lib_utils.isFn;
    var isArr = injecty_lib_utils.isArr;
    var isStr = injecty_lib_utils.isStr;
    var chain = injecty_lib_utils.chain;
    var fnName = injecty_lib_utils.fnName;
    var parseArgs = injecty_lib_utils.parseArgs;
}
var getter = function getter(pool) {
    return function (name) {
        return pool.map[name];
    };
};
var remove = function remove(pool) {
    return function (name) {
        return pool.map[name] ? pool.map[name] = void 0 : void 0;
    };
};
var register = function register(pool) {
    return function (name, value) {
        return isFn(name) ? function () {
            var lambdaø1 = name;
            var nameø2 = fnName(lambdaø1);
            return nameø2 ? pool.map[nameø2] = lambdaø1 : (function () {
                throw new TypeError('Function must have a name');
            })();
        }.call(this) : isStr(name) ? pool.map[name] = value : (function () {
            throw new TypeError('First argument is invalid');
        })();
    };
};
var flush = function flush(pool) {
    return function () {
        return pool.map = {};
    };
};
var getLambda = function getLambda(lambda) {
    return isArr(lambda) ? lambda.filter(function (val) {
        return isFn(val);
    })[0] : lambda;
};
var getArgs = function getArgs(lambda) {
    return isFn(lambda) ? isArr(lambda.$inject) ? lambda.$inject : parseArgs(lambda) : isArr(lambda) ? lambda.filter(isStr) : void 0;
};
var annotateArgs = function annotateArgs(lambda) {
    return function () {
        var argsø1 = getArgs(lambda);
        return isArr(argsø1) ? argsø1 : [];
    }.call(this);
};
var injector = function injector(getter, deps) {
    return isArr(deps) ? deps.map(function (name) {
        return function () {
            var depø1 = getter(name);
            return depø1 === void 0 ? (function () {
                throw new Error('Dependency not registered: ' + name);
            })() : depø1;
        }.call(this);
    }) : void 0;
};
var invoke = function invoke(getter) {
    return function (lambda) {
        return function () {
            var argsø1 = getArgs(lambda);
            var lambdaø2 = getLambda(lambda);
            var injectionsø1 = injector(getter, argsø1);
            return lambdaø2.apply(void 0, injectionsø1);
        }.call(this);
    };
};
var inject = function inject(invoke) {
    return function (lambda) {
        return function () {
            return invoke(lambda);
        };
    };
};
var injectable = function injectable(getter) {
    return function (name) {
        return getter(name) === void 0 ? false : true;
    };
};
var annotate = function annotate(getter) {
    return function (lambda) {
        return isStr(lambda) ? annotateArgs(getter(lambda)) : annotateArgs(lambda);
    };
};
var chainableMethods = [
    'register',
    'set',
    'flush',
    'remove'
];
var chainMethods = function chainMethods(ctx) {
    Object.keys(ctx).forEach(function (name) {
        return (chainableMethods.indexOf(name) === -1 ? false : true) ? function () {
            var methodø1 = ctx[name];
            return isFn(methodø1) ? ctx[name] = chain(ctx, methodø1) : void 0;
        }.call(this) : void 0;
    });
    return ctx;
};
var satisfies = function satisfies(getter) {
    return function (lamdba) {
        return function () {
            var argsø1 = annotateArgs(lamdba);
            return argsø1.filter(function (name) {
                return getter(name) === void 0 ? false : true;
            }).length === argsø1.length;
        }.call(this);
    };
};
var poolAccessor = function poolAccessor(pool) {
    return function () {
        return pool.map;
    };
};
var container = exports.container = function container(parent) {
    return function () {
        var poolø1 = newPool(parent);
        var getø1 = getter(poolø1);
        var setø1 = register(poolø1);
        var invokeø1 = invoke(getø1);
        var ctx = {
            'get': getø1,
            'require': getø1,
            'set': setø1,
            'register': setø1,
            'invoke': invokeø1,
            'inject': inject(invokeø1),
            'flush': flush(poolø1),
            'remove': remove(poolø1),
            '$$pool': poolAccessor(poolø1),
            'annotate': annotate(getø1),
            'satisfies': satisfies(getø1),
            'injectable': injectable(getø1)
        };
        return chainMethods(ctx);
    }.call(this);
};
},{"./types":3,"./utils":4}],2:[function(_dereq_,module,exports){
{
        var injecty_lib_utils = _dereq_('./utils');
    var isFn = injecty_lib_utils.isFn;
    var injecty_lib_container = _dereq_('./container');
    var container = injecty_lib_container.container;
}
var injecty = function injecty() {
    var args = Array.prototype.slice.call(arguments, 0);
    return container.apply(void 0, args);
};
var injectyFactory = function injectyFactory() {
    var args = Array.prototype.slice.call(arguments, 0);
    return function () {
        var injectyø1 = injecty.apply(void 0, args);
        injectyø1['container'] = injectyFactory;
        return injectyø1;
    }.call(this);
};
module.exports = injectyFactory();
},{"./container":1,"./utils":4}],3:[function(_dereq_,module,exports){
{
        var injecty_lib_utils = _dereq_('./utils');
    var isObj = injecty_lib_utils.isObj;
    var isFn = injecty_lib_utils.isFn;
}
var getParent = function getParent(parent) {
    return isFn(parent.$$pool) ? parent.$$pool() : parent;
};
var newPool = exports.newPool = function newPool(parent) {
    return function () {
        var poolø1 = { 'map': {} };
        isObj(parent) ? poolø1['map'] = Object.create(getParent(parent)) : void 0;
        return poolø1;
    }.call(this);
};
},{"./utils":4}],4:[function(_dereq_,module,exports){
var toString = Object.prototype.toString;
var argsRegex = new RegExp('^function(\\s*)(\\w*)[^(]*\\(([^)]*)\\)', 'm');
var fnNameRegex = new RegExp('^function\\s*(\\w+)\\s*\\(', 'i');
var isFn = exports.isFn = function isFn(o) {
    return typeof(o) === 'function';
};
var isStr = exports.isStr = function isStr(o) {
    return toString.call(o) === '[object String]';
};
var isObj = exports.isObj = function isObj(o) {
    return toString.call(o) === '[object Object]';
};
var isArr = exports.isArr = function isArr(o) {
    return toString.call(o) === '[object Array]';
};
var chain = exports.chain = function chain(obj, fn) {
    return function () {
        fn.apply(void 0, arguments);
        return obj;
    };
};
var fnName = exports.fnName = function fnName(lambda) {
    return isFn(lambda) ? lambda.name ? lambda.name : function () {
        var nameø1 = fnNameRegex.exec(lambda.toString());
        return nameø1 && nameø1[1] ? nameø1[1] : void 0;
    }.call(this) : void 0;
};
var parseArgs = exports.parseArgs = function parseArgs(lambda) {
    return isFn(lambda) ? function () {
        var matchesø1 = argsRegex.exec(lambda.toString());
        return matchesø1 && matchesø1[3] ? matchesø1[3].split(new RegExp('\\s*,\\s*')) : void 0;
    }.call(this) : void 0;
};
},{}]},{},[2])
(2)
});