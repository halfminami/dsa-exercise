(ns cops-and-robbers.arena.util
  (:require
   [cops-and-robbers.data.component :as comp]
   [cops-and-robbers.data.util :refer [first-rest]]
   ))

(defn all-connected-component
  "Returns all connected components of `graph - vertices`.
  `vertices` is hash-map.
  Returns list of lists.

  Example:
  ```
  > (all-connected-component {:a #{:b :c} :c #{:a} :b #{:a}} #{:a})
  ((:b) (:c))
  ```"
  ([graph vertices] (all-connected-component graph vertices (keys graph)))
  ([graph vertices to-be-checked]
   (loop [acc '() visited vertices to-be-checked to-be-checked]
     (if (empty? to-be-checked)
       acc
       (let [[v to-be-checked] (first-rest to-be-checked)]
         (if (contains? visited v)
           (recur acc visited to-be-checked)
           (let [component (comp/connected-component graph visited v)]
             (recur (conj acc component) (into visited component) to-be-checked))))))))

(defn edges->directed-graph
  "Returns directed graph constructed from `edges`.
  `edges` is a collection of vector `[x y]` and for each of the pair
  an edge x -> y is created.

  ```
  > (edges->directed-graph [[:x :y] [:a :z] [:y :z]])
  {:x #{:y}, :a #{:z}, :y #{:z}
  ```"
  ([edges] (edges->directed-graph {} edges))
  ([graph edges]
   (if (empty? edges)
     graph
     (let [[edge edges] (first-rest edges)
           [x y]        edge]
       (recur (assoc graph x (conj (graph x #{}) y))
              edges)))))

(defn edges->undirected-graph
  "Returns undirected graph using `edges->directed-graph` twice.

  ```
  > (edges->undirected-graph [[:x :y] [:a :z] [:y :z]])
  {:x #{:y}, :a #{:z}, :y #{:z :x}, :z #{:y :a}
  ```"
  ([edges] (edges->undirected-graph {} edges))
  ([graph edges]
   (-> (edges->directed-graph graph edges)
       (edges->directed-graph ,,, (map (fn [[x y]] [y x]) edges)))))

(defn complete-bipartite
  "Returns all possible edges from `sources` to `sinks`.

  ```
  > (complete-bipartite [:a :b] [1 2 3])
  ([:a 1] [:a 2] [:a 3] [:b 1] [:b 2] [:b 3])
  ```"
  [sources sinks]
  (for [source sources sink sinks]
    [source sink]))
