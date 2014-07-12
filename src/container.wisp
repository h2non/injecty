(ns injecty.lib.container
  (:require
    [injecty.lib.types :refer [new-pool]]
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
    (if (arr? (.-$inject lambda))
      (.-$inject lambda)
      (parse-args lambda))
    (cond (arr? lambda)
      (.filter lambda str?))))

(defn ^:private annotate-args
  [lambda]
  (let [args (get-args lambda)]
    (if (arr? args)
      args [])))

(defn ^:private invoke
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

(defn ^:private inject
  [invoke]
  (fn [lambda]
    (fn [& args]
      (apply invoke args))))

(defn ^:private annotate
  [getter]
  (fn [lambda]
    (if (str? lambda)
      (annotate-args (getter lambda))
      (annotate-args lambda))))

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
  (let [pool (new-pool parent)
        get (getter pool)
        set (register pool)
        invoke (invoke get)]
    (def ctx
      { :get get
        :require get
        :set set
        :register set
        :invoke invoke
        :inject (inject invoke)
        :flush (flush pool)
        :remove (remove pool)
        :annotate (annotate get)
        :injectable (injectable getter) }) (chain-methods ctx)))
