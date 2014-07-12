(ns promitto.lib.deferred
  (:require
    [promitto.lib.utils :refer [fn? ->arr promise? next-tick chain]]
    [promitto.lib.types :refer [states new-state new-pool new-buf]]
    [promitto.lib.promise :refer [promise]]))

(defn ^:private pusher
  [pool]
  (fn [type fn]
    (cond (fn? fn)
      (.push (aget pool type) fn))))

(defn ^:private switch-state
  [state]
  (fn [type]
    (cond
      (and (not (? type :notify)) (.-pending state))
      (do
        (set! (.-pending state) false)
        (cond (? type :resolve)
          (set! (.-resolve state) true))
        (cond (? type :reject)
          (set! (.-reject state) true))))))

(defn ^:private cache-args
  [buf]
  (fn [type args]
    (set! (aget buf type) (->arr args))))

(defn ^:private buf-args
  [state buf]
  (fn [type fn]
      (if (? type :finally)
        (if (.-reject state)
          (.-reject buf)
          (.-resolve buf))
        (aget buf type))))

(defn ^:private flush
  [pool]
  (fn [name]
    (.splice (aget pool name) 0)))

(defn ^:private dispatcher
  [state pool buf]
  (let [flush (flush pool)
        get-args (buf-args state buf)]
    (fn [type]
      (.for-each (aget pool type)
        (fn [lamdba]
          (let [args (get-args type lamdba)]
            (apply lamdba args))))
      (cond (!? type :notify)
        (flush type)))))

(defn ^:private dispatch
  [state pool buf]
  (let [dispatcher (dispatcher state pool buf)]
    (fn [type]
      (next-tick
        (fn []
          (cond (or (aget state type) (? type :notify))
            (dispatcher type))
          (cond (not (.-pending state))
            (dispatcher :finally)))))))

(defn ^:private apply-state
  [cache-args switch-state dispatch]
  (fn [type args]
    (cache-args type args)
    (switch-state type)
    (dispatch type)))

(defn ^:private call-state
  [apply-fn]
  (fn [type]
    (fn []
      (apply-fn type arguments))))

(defn ^:private notify
  [cache-args dispatch]
  (fn []
    (cache-args :notify arguments)
    (dispatch :notify)))

(defn ^:private chain-deferred
  [ctx]
  (.for-each (.keys Object ctx)
    (fn [name]
      (let [member (aget ctx name)]
        (cond (!? name :promise)
          (set! (aget ctx name)
            (chain ctx member)))))) ctx)

(defn ^object deferred
  "Create a new deferred object"
  []
  (let [buf (new-buf)
        pool (new-pool)
        state (new-state)
        pusher (pusher pool)
        cache-args (cache-args buf)
        switch-state (switch-state state)
        dispatch (dispatch state pool buf)
        apply (apply-state cache-args switch-state dispatch)
        call-state (call-state apply)]
    (def ctx
      { :resolve (call-state :resolve)
        :reject (call-state :reject)
        :notify (notify cache-args dispatch)
        :promise (promise state pusher dispatch) }) (chain-deferred ctx)))

(defn ^promise resolved
  "Returns a promise with resolve status with a custom reason"
  [reason]
  (let [defer (deferred)]
    (.resolve defer reason)
    (.-promise defer)))

(defn ^promise rejected
  "Returns a promise with reject status with a custom reason"
  [reason]
  (let [defer (deferred)]
    (.reject defer reason)
    (.-promise defer)))

(defn ^promise when
  "Wrap a value as a promise-like object"
  [value reason]
  (if (promise? value)
    value
    (resolved reason)))
