(ns injecty.lib.macros)

(defmacro ?
  [x y]
  `(identical? ~x ~y))

(defmacro !?
  [x y]
  `(if (? ~x ~y) false true))

(defmacro unless
  [condition form]
  (list 'if condition nil form))
