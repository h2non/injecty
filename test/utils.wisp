(ns inj.test.helpers
  (:require
    [chai :refer [expect]]
    [inj.lib.utils :refer [fn? arr? parse-args]]))

(describe :isFn
  (fn []
    (it "should be a function"
      (fn []
        (.-to.be.true (expect (fn? (fn []))))
        (.-to.be.true (expect (fn? (Function.))))))
    (it "should not be a function"
      (fn []
        (.-to.be.false (expect (fn? {})))
        (.-to.be.false (expect (fn? [])))
        (.-to.be.false (expect (fn? nil)))
        (.-to.be.false (expect (fn? "")))
        (.-to.be.false (expect (fn? null)))))))

(describe :isArr
  (fn []
    (it "should be an array"
      (fn []
        (.-to.be.true (expect (arr? [])))
        (.-to.be.true (expect (arr? (Array.))))))
    (it "should not be an array"
      (fn []
        (.-to.be.false (expect (arr? {})))
        (.-to.be.false (expect (arr? (fn []))))
        (.-to.be.false (expect (arr? nil)))
        (.-to.be.false (expect (arr? "")))
        (.-to.be.false (expect (arr? Date)))
        (.-to.be.false (expect (arr? 1)))
        (.-to.be.false (expect (arr? null)))))))

(describe :parseArgs
  (fn []
    (it "should parse and extract the argument"
      (fn []
        (.to.deep.equal (expect (parse-args (fn [name]))) [:name])))
    (it "should parse and extract multiple arguments"
      (fn []
        (.to.deep.equal (expect (parse-args (fn [name age gender]))) [:name :age :gender])))
    (it "should not parse if value is not a function"
      (fn []
        (.to.be.equal (expect (parse-args [])) nil)))))
