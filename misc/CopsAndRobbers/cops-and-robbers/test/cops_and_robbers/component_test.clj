(ns cops-and-robbers.component-test
  (:require [clojure.test :refer :all]
            [cops-and-robbers.data.component :refer :all]))

(defn compt= [want got] (= (sort want) (sort got)))

(deftest empty-test
  (is (compt= '(:x)
              (connected-component {} :x))))

(deftest simple-test
  (is (compt= '(:y :x :z)
              (connected-component {:x #{:y :z} :y #{:x} :z #{:x}} :z)))
  (is (compt= '(:z)
              (connected-component {:x #{:y :z} :y #{:x} :z #{:x}} #{:x} :z))))

(deftest complete-test
  (let [k4 {:x #{:y :z :w} :y #{:x :z :w} :z #{:x :w :y} :w #{:x :y :z}}]
    (is (compt= '(:x :y :z :w)
                (connected-component k4 :z)))
    (is (compt= '(:w :y :z)
                (connected-component k4 #{:x} :z)))))
