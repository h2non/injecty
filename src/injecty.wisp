(ns injecty.lib.index
  (:require
    [injecty.lib.utils :refer [fn?]]
    [injecty.lib.container :refer [container]]))

(defn ^:private injecty
  [& args]
  (apply container args))

(defn ^:private injecty-factory
  [& args]
  (let [injecty (apply injecty args)]
    (set! (aget injecty :container) injecty-factory) injecty))

(set! (.-exports module) (injecty-factory))
