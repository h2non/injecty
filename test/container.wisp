(ns inj.test.deferred
  (:require
    [chai :refer [expect]]
    [inj.lib.inj :as inj]))

(describe :container
  (fn []
    (describe :api
      (fn []
        (it "should expose a default global container"
            (fn []
              (.to.be.an (expect inj) :object)))
        (it "should create a new container"
          (fn []
            (.to.be.an (expect (.container inj)) :object)))))
    (describe :register
      (fn []
        (describe :object
          (fn []
            (it "should register Math as alias"
              (fn []
                (.to.be.an (expect (.register inj :Math Math)) :object)))
            (it "should get Math dependency"
              (fn []
                (.to.deep.equal (expect (.get inj :Math)) Math)))))
        (describe :error
          (fn []
            (it "should throw an error if it is a invalid type"
              (fn []
                (.to.throw (expect (fn [] (.register inj nil))) TypeError)))
            (it "should throw a type error if the function is not named"
              (fn []
                (.to.throw (expect (fn [] (.register inj (fn [])))) TypeError)))))))
    (describe :inject
      (fn []
        (describe :function
          (fn []
            (it "should inject dependencies parsing arguments"
              (fn []
                (let [lambda (fn [Math] (.round Math))]
                  (.to.be.an (expect (.inject inj lambda)) :number))))
            (it "should throw and exeception is cannot inject a dependency"
              (fn []
                (.to.throw (expect (fn [] (.inject inj :empty))) Error)))))))))
