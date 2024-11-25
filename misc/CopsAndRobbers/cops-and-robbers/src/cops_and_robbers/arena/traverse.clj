(ns cops-and-robbers.arena.traverse
  (:require
   [cops-and-robbers.data.util :refer [first-rest]]
   ))

(declare dfs)

(defn- dfs-loop [graph state node neighbor ok?]
  (println :loop [(:cops node) (:robber node)] (map (fn [x] [(:cops x) (:robber x)]) neighbor))
  (if (empty? neighbor)
    [:stuck state]
    (loop [neighbor neighbor state state]
      (if (empty? neighbor)
        [:ok state]
        (let [[fst neighbor] (first-rest neighbor)]
          (if (= :closed (state [node fst]))
            (recur neighbor state)
            (let [state       (assoc state [node fst] :open)
                  [sym state] (dfs graph state fst ok?)
                  state       (assoc state [node fst] :closed)]
              (if (= :stuck sym)
                [sym state]
                (recur neighbor state)))))
        #_
        (let [[fst neighbor] (first-rest neighbor)
              state          (assoc state [node fst] :open)
              [sym state]    (dfs graph state fst ok?)
              state          (assoc state [node fst] :closed)]
          (if (= :ok sym)
            (recur neighbor state)
            [sym state]))))))

(defn dfs
  [graph state node ok?]
  (println :call [(:cops node) (:robber node)])
  (let [[sym state]
        (if (ok? node)
          [:ok state]
          (let [neighbor (graph node)]
            (if (empty? neighbor)
              [:ok? state]
              (let [neighbor (remove #(= :open (state [node %])) neighbor)]
                (dfs-loop graph state node neighbor ok?))))
          #_
          (let [neighbor (graph node)
                neighbor (remove #(= :open (state [node %])) neighbor)]
            (dfs-loop graph state node neighbor ok?)))]
    (println sym (map (fn [[[x y] _]] [(:cops x) (:robber x) (:cops y) (:robber y)]) (filter #(= :open (second %)) state)))
    [sym state]))

#_#_
(defn- dfs-loop [graph state node neighbor ok?]
  (if (empty? neighbor)
    [:stuck state]
    (loop [neighbor neighbor state state]
      (if (empty? neighbor)
        [:ok state]
        (let [[fst neighbor] (first-rest neighbor)
              [sym state]    (dfs graph state fst ok?)]
          (if (= :ok sym)
            (recur neighbor state)
            [sym state]))))))

(defn dfs
  "DFS with node check for traversing the arena."
  [graph state node ok?]
  {:pre [(not (= :open (state node)))]}
  (println :call (:cops node) (:robber node))
  (if (= :closed (state node))
    [:ok state]
    (let [state (assoc state node :open)
          [sym state]
          (if (ok? node)
            [:ok state]
            (let [neighbor (graph node)
                  neighbor (remove #(= :open (state %1)) neighbor)]
              (dfs-loop graph state node neighbor ok?)))]
      (println sym node)
      [sym (assoc state node :closed)])))
