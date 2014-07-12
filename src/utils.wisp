(ns promitto.lib.utils)

(def ^:private ->string
  (.-prototype.->string Object))

(def ^:private args-regex
  (RegExp. "^function(\\s*)(\\w*)[^(]*\\(([^)]*)\\)" "m"))

(def ^:private fn-name-regex
  (RegExp. "^function\\s*(\\w+)\\s*\\(" "i"))

(defn ^boolean fn?
  "Check if the given object is a function type"
  [o]
  (? (typeof o) :function))

(defn ^boolean str?
  "Check if the given value is a string"
  [o]
  (? (typeof o) :string))

(defn ^boolean obj?
  "Check if the given value is a plain object"
  [o]
  (? (.call ->string o) "[object Object]"))

(defn ^boolean arr?
  "Check if the given value is an array"
  [o]
  (? (.call ->string o) "[object Array]"))

(defn ^array ->arr
  "Convert arguments object into array"
  [o]
  (.call (.-slice (.-prototype Array)) o))

(defn ^fn chain
  [obj fn]
  (fn []
    (apply fn arguments) obj))

(defn ^:string fn-name
  [lambda]
  (cond (fn? lambda)
    (if (.-name lambda)
      (.-name lambda)
      (let [name (.exec fn-name-regex (.to-string lambda))]
        (cond (and name (aget name 1))
          (aget name 1))))))

(defn ^array parse-args
  [lambda]
  (cond (fn? lambda)
    (let [matches (.exec args-regex (.to-string lambda))]
      (if (and matches (aget matches 3))
        (.split (aget matches 3) (RegExp. "\\s*,\\s*")) nil))))
