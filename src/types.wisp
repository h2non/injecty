(ns injecty.lib.types
  (:require
    [injecty.lib.utils :refer [obj?]]))

(defn ^object new-pool
  "Creates a new dependencies pool"
  [parent]
  (let [pool {:map {}}]
    (cond (obj? parent)
      (set! (aget pool :map) (.create Object parent))) pool))
