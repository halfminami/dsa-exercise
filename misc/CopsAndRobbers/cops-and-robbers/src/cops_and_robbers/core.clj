(ns cops-and-robbers.core
  (:require
   [cops-and-robbers.arena :as arena]
   ))

;; failing :c
(defn hello
  []
  (let [g (arena/make-graph [[:a :b] [:b :c] [:c :a]])
        a (arena/make-arena g 3)]
    (arena/cops-win? a)))
