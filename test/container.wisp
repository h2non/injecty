(ns injecty.test.deferred
  (:require
    [chai :refer [expect]]
    [injecty.lib.injecty :as injecty]))

(describe :container
  (fn []
    (describe :api
      (fn []
        (it "should expose a default global container"
            (fn []
              (.to.be.an (expect injecty) :object)))
        (it "should create a new container"
          (fn []
            (.to.be.an (expect (.container injecty)) :object)))))
    (describe :register
      (fn []
        (describe :object
          (fn []
            (it "should register Math as alias"
              (fn []
                (.to.be.an (expect (.register injecty :Math Math)) :object)))
            (it "should get Math dependency"
              (fn []
                (.to.deep.equal (expect (.get injecty :Math)) Math)))))
        (describe :error
          (fn []
            (it "should throw an error if it is a invalid type"
              (fn []
                (.to.throw (expect (fn [] (.register injecty nil))) TypeError)))
            (it "should throw a type error if the function is not named"
              (fn []
                (.to.throw (expect (fn [] (.register injecty (fn [])))) TypeError)))))))
    (describe :inject
      (fn []
        (describe :function
          (fn []
            (it "should inject dependencies parsing arguments"
              (fn []
                (let [lambda (fn [Math] (.round Math))]
                  (.to.be.an (expect (.invoke injecty lambda)) :number))))
            (it "should throw and exeception is cannot inject a dependency"
              (fn []
                (.to.throw (expect (fn [] (.invoke injecty :empty))) Error)))))))
    (describe :annotate
      (fn []
        (describe :arguments
          (fn []
            (it "should return the requested injections parsing arguments"
              (fn []
                (let [lambda (fn [Math Date])]
                  (.to.deep.equal (expect (.annotate injecty lambda)) [:Math :Date]))))
            (it "should return an empty injections"
              (fn []
                (.to.deep.equal (expect (.annotate injecty (fn []))) [])))))
        (describe :$inject
          (fn []
            (it "should return the requested injections parsing $inject"
              (fn []
                (let [lambda (fn [])]
                  (set! (aget lambda :$inject) [:Math :Date])
                  (.to.deep.equal (expect (.annotate injecty lambda)) [:Math :Date]))))
            (it "should return an empty injections"
              (fn []
                (let [lambda (fn [])]
                  (set! (aget lambda :$inject) nil)
                  (.to.deep.equal (expect (.annotate injecty lambda)) []))))))
        (describe :array
          (fn []
            (it "should return the requested injections from the array"
              (fn []
                (let [lambda [:Math :Date (fn [])]]
                  (.to.deep.equal (expect (.annotate injecty lambda)) [:Math :Date]))))
            (it "should return an empty injections"
              (fn []
                (.to.deep.equal (expect (.annotate injecty [(fn [])])) [])))))))))
