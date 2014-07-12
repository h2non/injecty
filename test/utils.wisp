(ns injecty.test.helpers
  (:require
    [chai :refer [expect]]
    [injecty.lib.utils :refer [fn? arr? str? chain fn-name parse-args]]))

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

(describe :isStr
  (fn []
    (it "should be a string"
      (fn []
        (.-to.be.true (expect (str? :a)))
        (.-to.be.true (expect (str? (String.))))))
    (it "should not be a string"
      (fn []
        (.-to.be.false (expect (str? {})))
        (.-to.be.false (expect (str? (fn []))))
        (.-to.be.false (expect (str? nil)))
        (.-to.be.false (expect (str? 1)))
        (.-to.be.false (expect (str? Date)))
        (.-to.be.false (expect (str? null)))))))

(describe :chain
  (fn []
    (it "should return the chained object when invoke"
      (fn []
        (let [ctx {:a true}
              lambda (fn [] 1)]
          (.to.be.equal (expect ((chain ctx lambda))) ctx))))
    (it "should return the chained object when invoke"
      (fn []
        (.to.be.equal (expect ((chain Date (fn [])))) Date)))))

(describe :fnName
  (fn []
    (it "should extract the function name"
      (fn []
        (.to.be.equal (expect (fn-name (fn Test[name]))) :Test)))
    (it "should not extract the function name"
      (fn []
        (.to.be.equal (expect (fn-name (fn []))) nil)
        (.to.be.equal (expect (fn-name [])) nil)))))

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
