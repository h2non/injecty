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
    (cond (aget (.-map pool) name)
      (set! (aget (.-map pool) name) nil))))

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

(defn ^:private injector
  [getter deps]
  (cond (arr? deps)
    (.map deps
      (fn [name]
        (let [dep (getter name)]
          (if (? dep nil)
            (throw (Error. (+ "Dependency not registered: " name))) dep))))))

(defn ^:private invoke
  [getter]
  (fn [lambda]
    (let [args (get-args lambda)
          lambda (get-lambda lambda)
          injections (injector getter args)]
      (apply lambda injections))))

(defn ^:private inject
  [invoke]
  (fn [lambda]
    (fn []
      (invoke lambda))))

(defn ^:private injectable
  [getter]
  (fn [name]
    (!? (getter name) nil)))

(defn ^:private annotate
  [getter]
  (fn [lambda]
    (if (str? lambda)
      (annotate-args (getter lambda))
      (annotate-args lambda))))

(def ^:private chainable-methods
  [:register :set :flush :remove])

(defn ^:private chain-methods
  [ctx]
  (.for-each (.keys Object ctx)
    (fn [name]
      (cond (!? (.index-of chainable-methods name) -1)
        (let [method (aget ctx name)]
          (cond (fn? method)
            (set! (aget ctx name) (chain ctx method))))))) ctx)

(defn ^:private satisfies
  [getter]
  (fn [lamdba]
    (let [args (annotate-args lamdba)]
      (? (.-length
        (.filter args (fn [name] (!? (getter name) nil)))) (.-length args)))))

(defn ^:private pool-accessor
  [pool]
  (fn [] (.-map pool)))

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
        :$$pool (pool-accessor pool)
        :annotate (annotate get)
        :satisfies (satisfies get)
        :injectable (injectable get) }) (chain-methods ctx)))
