(ns inj.lib.index
  (:require
    [inj.lib.utils :refer [fn?]]
    [inj.lib.container :refer [container]]))

(defn ^:private inj
  [& args]
  (apply container args))

(defn ^:private inj-factory
  [& args]
  (let [inj (apply inj args)]
    (set! (aget inj :container) inj-factory) inj))

(set! (.-exports module) (inj-factory))
