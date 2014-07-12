(ns injecty.lib.types
  (:require
    [injecty.lib.utils :refer [obj? fn?]]))

(defn ^:private get-parent
  [parent]
  (if (fn? (.-$$pool parent))
    ((.-$$pool parent)) parent))

(defn ^object new-pool
  "Creates a new dependencies pool"
  [parent]
  (let [pool {:map {}}]
    (cond (and (obj? parent))
      (set! (aget pool :map)
        (.create Object (get-parent parent)))) pool))
