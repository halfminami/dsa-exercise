(ns cops-and-robbers.data.component
  (:require
   [cops-and-robbers.data.util :refer [first-rest]]
   ))

(defn- traverse [graph visited start]
  (loop [acc     '()
         visited (conj visited start)   ; (is/was) on stack
         stack   (list start)]
    (if (empty? stack)
      acc
      (let [[cur stack] (first-rest stack)
            acc         (conj acc cur)
            neighbor    (graph cur)
            unvisited   (remove #(contains? visited %1) neighbor)]
        (recur acc (into visited unvisited) (concat unvisited stack))))))

(defn connected-component
  "Returns list of vertices in a connected component containing `start`.
  
  `graph` is a map whose values are sets.
  When `visited` is given, which is a set of vertices, it won't visit
  them in the graph.

  Examples:
  ```
  ;; y <-> x <-> z
  > (connected-component {:x #{:y :z} :y #{:x} :z #{:x}} :z)
  (:y :x :z)

  > (connected-component {:x #{:y :z} :y #{:x} :z #{:x}} #{:x} :z)
  (:z)
  ```"
  ([graph start] (traverse graph #{} start))
  ([graph visited start] (traverse graph visited start)))
