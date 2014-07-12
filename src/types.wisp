(ns inj.lib.types
  (:require
    [inj.lib.utils :refer [obj?]]))

(defn ^array new-container
  [parent]
  (.create Object parent))
