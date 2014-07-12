(ns injecty.lib.types
  (:require
    [injecty.lib.utils :refer [obj?]]))

(defn ^:private get-parent
  [parent]
  (if (obj? (.-$$pool parent))
    (.-$$pool parent) parent))

(defn ^object new-pool
  "Creates a new dependencies pool"
  [parent]
  (let [pool {:map {}}]
    (cond (and (obj? parent))
      (set! (aget pool :map)
        (.create Object (get-parent parent)))) pool))
