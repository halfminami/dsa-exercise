#lang racket/base

(require "graph.rkt"
         "../../../util/racket/thread.rkt"
         racket/set
         racket/list)

(provide isomorphic?)

(define (adjacent? graph x y)
  (--> (graph-adjacency-list graph) (hash-ref x (set)) (set-member? y)))

(define (iff? p q) (or (and p q) (and (not p) (not q))))

(define (vertices-stream graph) (--> (graph-vertices graph) (set->stream)))

;; graph $G$ and $H$ are isomorphic:
;; $\exists f: V(G) \to V(H).\, [\forall u,v \in V(G).\, uv \in A(G) \iff f(u)f(v) \in A(H)]$
;; + $f$ is bijective
(define (same-graph? graph-a graph-b f)
  (for/and ([u (vertices-stream graph-a)])
    (for/and ([v (vertices-stream graph-a)])
      (iff? (adjacent? graph-a u v) (adjacent? graph-b (f u) (f v))))))

(define ((make-f rel) x) (hash-ref rel x))

(define (graph-size graph) (--> (graph-vertices graph) (set-count)))

;; isomorphism test for small graphs
(define (isomorphic? graph-a graph-b)
  (cond
    [(= (graph-size graph-a) (graph-size graph-b))
     (for/or ([b-perm (--> (graph-vertices graph-b)
                           (set->list)
                           (in-permutations))])
       (define rel (for/hash ([a (vertices-stream graph-a)] [b (in-list b-perm)])
                     (values a b)))
       (same-graph? graph-a graph-b (make-f rel)))]
    [else #f]))

(module+ test
  (require rackunit
           rackunit/text-ui)

  (define isomorphic?-tests
    (test-suite
     "isomorphic?"

     (check-true (isomorphic? (make-graph '((a b) (b c)))
                              (make-graph '((x y) (y z)))))

     (check-true (isomorphic? (make-graph '((a b) (b c) (c a)))
                              (make-graph '((x y) (y z) (z x)))))

     (check-false (isomorphic? (make-graph '((a b) (c b)))
                               (make-graph '((x y) (x z)))))

     (check-false (isomorphic? (make-graph '((a b)) #:isolated '(c))
                               (make-graph '((x y)))))
     
     (check-false (isomorphic? (make-graph '((a b) (b a) (b c)))
                               (make-graph '((x y) (y z)))))

     (check-true (isomorphic? (make-graph '((a b) (d c) (b c)))
                              (make-graph '((x y) (z w) (w y)))))

     (check-true (isomorphic? (make-graph '() #:isolated '(a))
                              (make-graph '() #:isolated '(x))))))

  (run-tests isomorphic?-tests))
