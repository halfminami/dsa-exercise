(ns cops-and-robbers.backtrack-test
  (:require [clojure.test :refer :all]
            [cops-and-robbers.data.backtrack :refer :all]))

(defn cmp [a b]
  (cond
    (empty? a) true
    (empty? b) false
    :else (and (< (first a) (first b))
               (cmp (rest a) (rest b)))))

(defn bt= [want got]
  (= (sort cmp (map sort want))
     (sort cmp (map sort got))))

(deftest empty-test
  (is (bt= '() (backtrack 2 3)))
  (is (bt= '() (backtrack 10 (fn [on v] true) (fn [on v] false)))))

(deftest subsets-test
  (is (bt= '(()) (backtrack 0)))
  (is (bt= '(() (0) (1) (0 1)) (backtrack 2)))
  (is (bt= '(() (0)) (backtrack 1))))

(deftest combination-test
  (is (bt= '((0) (1)) (backtrack 2 1)))
  (is (bt= '((0 1)) (backtrack 2 2)))
  (is (bt= '(()) (backtrack 2 0))))

(deftest pred-test
  (is (bt= '((3) (2) (2 3) (1) (1 3) (1 2) (1 2 3) (0) (0 3) (0 1) (0 1 3))
           (backtrack 4
                      (fn [on v] (or (and (get v 0) (get v 2))
                                     (> on 3)))
                      (fn [on v] (and (not (and (get v 0) (get v 2)))
                                      (<= 1 on 3)))))))
