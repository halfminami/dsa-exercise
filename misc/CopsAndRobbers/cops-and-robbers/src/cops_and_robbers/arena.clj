(ns cops-and-robbers.arena
  (:require
   [cops-and-robbers.arena.traverse :as traverse]
   [cops-and-robbers.arena.node :as node]
   [cops-and-robbers.arena.defs :refer [->Node]]
   [cops-and-robbers.arena.util :as util]
   ))

(defn make-graph
  "Returns undirected graph where the game takes place.

  Example:
  ```
  > (make-graph [[0 1] [1 2] [2 3] [3 0]])
  {0 #{1 3}, 1 #{0 2}, 2 #{1 3}, 3 #{0 2}}
  ```"
  [edges]
  (util/edges->undirected-graph edges))

;; TODO: is graph connected?

(defn- make-all-cops-configuration
  "Returns all of the cops configuration.
  It is list of hash-set of vertices, not indices. 

  Example:
  ```
  > (make-all-cops-configuration [:a :b :c] 3 2)
  (#{:c :b} #{:c :a} #{:b :a} #{:c} #{:b} #{:a})
  ```"
  [all-indexed n k]
  (let [config-list (node/all-cops-configuration n k)]
    (map #(into #{} (map all-indexed %1)) config-list)))
#_
(defn- nodes-of-k-cops
  "Returns list of nodes that is holding `k` cops.
  `cops-robbers` is a list of `[cops robbers]`.

  Example:
  ```
  > (def cops-robbers (make-pair-cops-robbers {:a #{:b} :b #{:a :c} :c #{:b}} [:a :b :c] 3 2))
  > (nodes-of-k-cops cops-robbers 2)
  ({:cops #{:c :b}, :robber #{:a}}
   {:cops #{:c :a}, :robber #{:b}}
   {:cops #{:b :a}, :robber #{:c}})
  ```"
  [cops-robbers k]
  (let [k-cops-robbers (filter #(= k (count (first %1))) cops-robbers)
        ;; If `robbers` is empty, which is the case k == n, then see that
        ;; `make-node` doesn't work.
        k-cops-robbers (map (fn [[cops robbers]]
                              [cops (or (not-empty robbers) '(#{}))])
                            k-cops-robbers)
        make-node      (fn [[cops robbers]] (map #(->Node cops %1) robbers))]
    (apply concat (map make-node k-cops-robbers))))

(defn- k-nodes-from-edges
  [edges k]
  (filter #(and (not-empty (:robber %)) (= k (count (:cops %))))
          (set (map first edges))))

(defn- make-pair-cops-robbers
  "Returns list of `[cops robbers]`.
  `cops` is hash-set. `robbers` is list of hash-set.

  Example:
  ```
  > (make-pair-cops-robbers {:a #{:b} :b #{:a :c} :c #{:b}} [:a :b :c] 3 2)
  ([#{:c :b} (#{} #{:a})]
   [#{:c :a} (#{} #{:b})]
   [#{:b :a} (#{} #{:c})]
   [#{:c} (#{} #{:b :a})]
   [#{:b} (#{} #{:c} #{:a})]
   [#{:a} (#{} #{:c :b})])
  ```"
  [graph all-indexed n k]
  (let [configs (make-all-cops-configuration all-indexed n k)]
    (map (fn [conf] [conf (node/all-robbers-of-cops graph conf)])
         configs)))

(defn- make-root-arcs
  "Returns all possible edges from `root` to nodes holding `k` cops.
  `root` is node."
  [root edges k]
  (let [k-nodes (k-nodes-from-edges edges k)]
    (util/complete-bipartite [root] k-nodes)))

(defn make-arena
  "`graph` is undirected graph where the game takes place.
  Cops will use `k` cops.
  `k` should be less than or equal to `n`."
  [graph k]
  (let [all-indexed (into [] (keys graph))
        n           (count all-indexed)]
    (if (>= k n)
      {:yes true}
      (let [cops-robbers (make-pair-cops-robbers graph all-indexed n k)
            edges        (node/all-edges-for-moves cops-robbers)
            root         (->Node #{} (into #{} all-indexed))
            root-arcs    (make-root-arcs root edges k)]
        {:graph (util/edges->directed-graph (concat edges root-arcs))
         :root  root}))))

(defn cops-win?
  "Tests if the cops can win the game."
  [arena]
  (or (:yes arena)
      (let [{:keys [graph root]} arena
            [sym _]              (traverse/dfs graph {} root #(empty? (:robber %1)))]
        (= :ok sym)))
  #_
  (let [{:keys [graph root]} arena
        [sym _]              (traverse/dfs graph {} root #(empty? (:robber %1)))]
    (= :ok sym)))
