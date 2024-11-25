(ns cops-and-robbers.arena.node
  (:require
   [cops-and-robbers.arena.util :as util]
   [cops-and-robbers.data.backtrack :as bt]
   [cops-and-robbers.arena.defs :refer [->Node]]
   [clojure.set :as set]
   ))

(defn all-robbers-of-cops
  "Returns all possible robbers for `cops`.
  `cops` is hash-set. Returns list of hash-set."
  [graph cops]
  (map #(into #{} %1) (util/all-connected-component graph cops)))

(defn all-cops-configuration
  "Combinations of k cops."
  [n k]
  (concat (bt/backtrack n k) (bt/backtrack n (dec k))))

(defn- placement
  "Returns edges representing placement of cops.
  `cops-j` must contain `cops-i`.
  They should differ by 1 in size so that it can add empty robber node properly
  when applicable.
  
  Examples:
  ```
  > (placement #{1 2} '(#{3 4} #{5}) #{1 2 3} '(#{4} #{5}))
  ([{:cops #{1 2}, :robber #{4 3}} {:cops #{1 3 2}, :robber #{4}}])
  ```
  
  ```
  > (placement #{1 2} '(#{3} #{4 5}) #{1 2 3} '(#{4 5}))
  ([{:cops #{1 2}, :robber #{3}} {:cops #{1 3 2}, :robber #{}}])
  ```"
  [cops-i robbers-i cops-j robbers-j]
  {:pre [(set/superset? cops-j cops-i)]}
  (let [captured (set/difference cops-j cops-i)
        edges    (for [rob-i robbers-i rob-j robbers-j]
                   (when (and (set/superset? rob-i captured)
                              (set/superset? rob-i rob-j))
                     [(->Node cops-i rob-i) (->Node cops-j rob-j)]))
        edges    (filter identity edges)]
    (if (empty? edges)
      (list [(->Node cops-i captured) (->Node cops-j #{})])
      edges)))

(defn- removal
  "Returns edges representing removal of cops.
  `cops-i` must contain `cops-j`.
  `:robber` won't expand its component after it became empty.

  Examples:
  ```
  > (removal #{1 2 3} '(#{4} #{5}) #{1 2} '(#{3 4} #{5}))
  ([{:cops #{1 3 2}, :robber #{4}} {:cops #{1 2}, :robber #{4 3}}]
   [{:cops #{1 3 2}, :robber #{5}} {:cops #{1 2}, :robber #{5}}])
  ```
  
  ```
  > (removal #{1 2 3} '(#{4} #{5}) #{1 2} '(#{3 4 5}))
  ([{:cops #{1 3 2}, :robber #{4}} {:cops #{1 2}, :robber #{4 3 5}}]
   [{:cops #{1 3 2}, :robber #{5}} {:cops #{1 2}, :robber #{4 3 5}}])
  ```"
  [cops-i robbers-i cops-j robbers-j]
  {:pre [(set/superset? cops-i cops-j)]}
  (let [released (set/difference cops-i cops-j)
        edges (for [rob-i robbers-i rob-j robbers-j]
                (when #_
                      (set/superset? rob-j rob-i)
                      ;#_
                      (and (not (empty? rob-i))
                           (or (= rob-j rob-i)
                               #_
                               (and (set/superset? rob-j rob-i)
                                    (= released (set/difference rob-j rob-i)))))
                  [(->Node cops-i rob-i) (->Node cops-j rob-j)]))]
    (filter identity edges)))

(defn- cops-move
  "Returns what kind of move cops are making from `cops-i` to `cops-j`.
  If it returns nil there should not be an edge between them."
  [cops-i cops-j]
  (cond
    (= cops-i cops-j)
    nil
    (set/superset? cops-i cops-j)
    :removal
    (set/superset? cops-j cops-i)
    :placement))

(defn all-edges-for-moves
  "Returns list of edges for arena.
  `cops-robbers` is a list of `[cops robbers]`.
  `robbers` is a list of hash-set. `cops` is hash-set.

  Examples:
  ```
  > (all-edges-for-moves '([#{:a :b} (#{:c} #{:d} #{})]
                           [#{:a} (#{:b :c :d} #{})]))
  ([{:cops #{:b :a}, :robber #{:c}} {:cops #{:a}, :robber #{:c :b :d}}]
   [{:cops #{:b :a}, :robber #{:d}} {:cops #{:a}, :robber #{:c :b :d}}]
   [{:cops #{:a}, :robber #{:c :b :d}} {:cops #{:b :a}, :robber #{:c}}]
   [{:cops #{:a}, :robber #{:c :b :d}} {:cops #{:b :a}, :robber #{:d}}]
   [{:cops #{:a}, :robber #{:c :b :d}} {:cops #{:b :a}, :robber #{}}])
  ```"
  [cops-robbers]
  (let [edges (for [pair-i cops-robbers pair-j cops-robbers]
                (let [[cops-i robbers-i] pair-i
                      [cops-j robbers-j] pair-j
                      move               (cops-move cops-i cops-j)]
                  (cond
                    (= :removal move)
                    (removal cops-i robbers-i cops-j robbers-j)
                    (= :placement move)
                    (placement cops-i robbers-i cops-j robbers-j))))]
    (apply concat edges)))
