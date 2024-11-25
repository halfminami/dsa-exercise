(ns cops-and-robbers.arena.defs)

(defrecord Node [cops robber])
;; arcs are simply vector [source sink]
