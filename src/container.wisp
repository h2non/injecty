(ns injecty.lib.container
  (:require
    [injecty.lib.utils :refer [fn? arr? str? chain fn-name parse-args]]))

(defn ^:private getter
  [pool]
  (fn [name]
    (aget (.-map pool) name)))

(defn ^:private remove
  [pool]
  (fn [name]
    (set! (aget pool name) nil)))

(defn ^:private register
  [pool]
  (fn [name value]
    (if (fn? name)
      (let [lambda name
            name (fn-name lambda)]
        (if name
          (set! (aget (.-map pool) name) lambda)
          (throw (TypeError. "Function must have a name"))))
      (if (str? name)
        (set! (aget (.-map pool) name) value)
        (throw (TypeError. "First argument is invalid"))))))

(defn ^:private flush
  [pool]
  (fn []
    (set! (.-map pool) {})))

(defn ^:private injector
  [getter deps]
  (let [buf []]
    (.map deps
      (fn [dep]
        (let [dep (getter dep)]
          (if (? dep nil)
            (throw (Error. (+ "Dependency not registered: " dep))) dep))))))

(defn ^:private get-lambda
  [lambda]
  (if (arr? lambda)
    (aget (.filter lambda (fn [val] (fn? val))) 0) lambda))

(defn ^:private get-args
  [lambda]
  (if (fn? lambda)
    (parse-args lambda)
    (cond (arr? lambda)
      (.filter arr
        (fn [dep] (? (typeof dep) :string))))))

(defn ^:private inject
  [getter]
  (fn [lambda]
    (let [args (get-args lambda)
          lambda (get-lambda lambda)
          injections (injector getter args)]
      (apply lambda injections))))

(defn ^:private injectable
  [getter]
  (fn [name]
    (!? (getter name) nil)))

(defn ^:private bind
  [inject]
  (fn [lambda]
    (fn [& args]
      (apply inject args))))

(defn ^:private chain-methods
  [ctx]
  (.for-each (.keys Object ctx)
    (fn [name]
      (cond (or (? name :register) (? name :set) (? name :flush))
        (let [method (aget ctx name)]
          (cond (fn? method)
            (set! (aget ctx name) (chain ctx method))))))) ctx)

(defn ^object container
  "Create a new dependency container"
  [parent]
  (let [pool {:map {}}
        get (getter pool)
        set (register pool)
        inject (inject get)]
    (def ctx
      { :get get
        :require get
        :set set
        :register set
        :inject inject
        :bind (bind inject)
        :flush (flush pool)
        :remove (remove pool)
        :injectable (injectable getter) }) (chain-methods ctx)))
