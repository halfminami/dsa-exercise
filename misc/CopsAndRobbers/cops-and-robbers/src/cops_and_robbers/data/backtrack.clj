(ns cops-and-robbers.data.backtrack)

(defn- bt [n set-count bin-vec quit? ok?]
  (cond
    (and (>= (count bin-vec) n) (ok? set-count bin-vec))
    (list (keep-indexed #(when %2 %1) bin-vec))
    (or (>= (count bin-vec) n) (quit? set-count bin-vec))
    nil
    :else
    (concat (bt n set-count (conj bin-vec false) quit? ok?)
            (bt n (inc set-count) (conj bin-vec true) quit? ok?))))

(defn backtrack
  "Returns list of subsets of `(range n)` using backtracking.
  
  When only `n` is given, returns all subsets of `(range n)`.
  When `n` and `k` are given, returns all subsets whose size is `k`.

  You can directly provide predicates for backtracking.
  When `quit?` is `true` it stops the search path.
  `ok?` is called when search ends and if it's `true` it is added to
  the sequence.
  Both predicates take two arguments. First one is the size of
  the current subset and second is a boolean vector representing candidates.
  It may not have enough length.

  Example: select 3 numbers from [0 1 2 3]
  ```
  > (let [n 4 k 3] (backtrack n k))
  ((1 2 3) (0 2 3) (0 1 3) (0 1 2))
  ```

  Example: subset of [0 1 2 3], 1 <= size <= 3, doesn't contain 0 and 2
  at the same time
  ```
  > (backtrack 4
               (fn [set-count bin-vec]
                 (or (and (get bin-vec 0) (get bin-vec 2))
                     (> set-count 3)))
               (fn [set-count bin-vec]
                 (and (not (and (get bin-vec 0) (get bin-vec 2)))
                           (<= 1 set-count 3))))
  ((3) (2) (2 3) (1) (1 3) (1 2) (1 2 3) (0) (0 3) (0 1) (0 1 3))
  ```"
  ([n] (backtrack n
                  (constantly false)
                  (constantly true)))
  ([n k] (backtrack n
                    (fn [set-count _bin-vec] (> set-count k))
                    (fn [set-count _bin-vec] (= set-count k))))
  ([n quit? ok?]
   {:pre [(nat-int? n)]}
   (bt (max 0 n) 0 [] quit? ok?)))
