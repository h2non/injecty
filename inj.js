/*! inj.js - v0.1 - MIT License - https://github.com/h2non/inj */
!function(e){if("object"==typeof exports&&"undefined"!=typeof module)module.exports=e();else if("function"==typeof define&&define.amd)define([],e);else{var f;"undefined"!=typeof window?f=window:"undefined"!=typeof global?f=global:"undefined"!=typeof self&&(f=self),f.inj=e()}}(function(){var define,module,exports;return (function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(_dereq_,module,exports){
{
        var inj_lib_utils = _dereq_('./utils');
    var isFn = inj_lib_utils.isFn;
    var isArr = inj_lib_utils.isArr;
    var isStr = inj_lib_utils.isStr;
    var chain = inj_lib_utils.chain;
    var fnName = inj_lib_utils.fnName;
    var parseArgs = inj_lib_utils.parseArgs;
}
var getter = function getter(pool) {
    return function (name) {
        return pool.map[name];
    };
};
var remove = function remove(pool) {
    return function (name) {
        return pool[name] = void 0;
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
var injector = function injector(getter, deps) {
    return function () {
        var bufø1 = [];
        return deps.map(function (dep) {
            return function () {
                var depø2 = getter(dep);
                return depø2 === void 0 ? (function () {
                    throw new Error('Dependency not registered: ' + depø2);
                })() : depø2;
            }.call(this);
        });
    }.call(this);
};
var getLambda = function getLambda(lambda) {
    return isArr(lambda) ? lambda.filter(function (val) {
        return isFn(val);
    })[0] : lambda;
};
var getArgs = function getArgs(lambda) {
    return isFn(lambda) ? parseArgs(lambda) : isArr(lambda) ? arr.filter(function (dep) {
        return typeof(dep) === 'string';
    }) : void 0;
};
var inject = function inject(getter) {
    return function (lambda) {
        return function () {
            var argsø1 = getArgs(lambda);
            var lambdaø2 = getLambda(lambda);
            var injectionsø1 = injector(getter, argsø1);
            return lambdaø2.apply(void 0, injectionsø1);
        }.call(this);
    };
};
var injectable = function injectable(getter) {
    return function (name) {
        return getter(name) === void 0 ? false : true;
    };
};
var chainMethods = function chainMethods(ctx) {
    Object.keys(ctx).forEach(function (name) {
        return name === 'register' || name === 'set' || name === 'flush' ? function () {
            var methodø1 = ctx[name];
            return isFn(methodø1) ? ctx[name] = chain(ctx, methodø1) : void 0;
        }.call(this) : void 0;
    });
    return ctx;
};
var container = exports.container = function container(parent) {
    return function () {
        var poolø1 = { 'map': {} };
        var getø1 = getter(poolø1);
        var setø1 = register(poolø1);
        var ctx = {
            'get': getø1,
            'set': setø1,
            'register': setø1,
            'inject': inject(getø1),
            'flush': flush(poolø1),
            'remove': remove(poolø1),
            'injectable': injectable(getter)
        };
        return chainMethods(ctx);
    }.call(this);
};
},{"./utils":3}],2:[function(_dereq_,module,exports){
{
        var inj_lib_utils = _dereq_('./utils');
    var isFn = inj_lib_utils.isFn;
    var inj_lib_container = _dereq_('./container');
    var container = inj_lib_container.container;
}
var inj = function inj() {
    var args = Array.prototype.slice.call(arguments, 0);
    return container.apply(void 0, args);
};
var injFactory = function injFactory() {
    var args = Array.prototype.slice.call(arguments, 0);
    return function () {
        var injø1 = inj.apply(void 0, args);
        injø1['container'] = injFactory;
        return injø1;
    }.call(this);
};
module.exports = injFactory();
},{"./container":1,"./utils":3}],3:[function(_dereq_,module,exports){
var toString = Object.prototype.toString;
var argsRegex = new RegExp('^function(\\s*)(\\w*)[^(]*\\(([^)]*)\\)', 'm');
var fnNameRegex = new RegExp('^function\\s*(\\w+)\\s*\\(', 'i');
var isFn = exports.isFn = function isFn(o) {
    return typeof(o) === 'function';
};
var isStr = exports.isStr = function isStr(o) {
    return typeof(o) === 'string';
};
var isObj = exports.isObj = function isObj(o) {
    return toString.call(o) === '[object Object]';
};
var isArr = exports.isArr = function isArr(o) {
    return toString.call(o) === '[object Array]';
};
var toArr = exports.toArr = function toArr(o) {
    return Array.prototype.slice.call(o);
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