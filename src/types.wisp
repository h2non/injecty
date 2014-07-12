(ns injecty.lib.types
  (:require
    [injecty.lib.utils :refer [obj?]]))

(defn ^array new-container
  [parent]
  (.create Object parent))
