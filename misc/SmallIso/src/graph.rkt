#lang racket/base

(require racket/set
         racket/match
         racket/list)

(provide make-graph
         (struct-out graph))

(module+ util
  (provide ->> -->))

;; Clojure `->` thread macro!
(define-syntax -->
  (syntax-rules ()
    [(--> init) init]
    [(--> acc (f args ...) rst ...) (--> (f acc args ...) rst ...)]
    [(--> acc f rst ...) (--> (f acc) rst ...)]))

;; `->>` thread last
(define-syntax ->>
  (syntax-rules ()
    [(->> init) init]
    [(->> acc (f args ...) rst ...) (->> (f args ... acc) rst ...)]
    [(->> acc f rst ...) (->> (f acc) rst ...)]))

(struct graph (vertices adjacency-list) #:transparent)

;; `arcs` is list of list
(define (make-graph arcs #:isolated [isolated '()])
  (graph (list->set (append* isolated arcs))
         (let ([ht (make-hash)])
           (for-each (match-lambda
                       [(list x y) (hash-update! ht x (λ (lst) (cons y lst)) '())])
                     arcs)
           (for-each (λ (k) (hash-update! ht k list->set)) (hash-keys ht))
           ht)))

(module+ test
  (require rackunit
           rackunit/text-ui)
  
  (define make-graph-tests
    (test-suite
     "make-graph"

     (check-equal? (make-graph '((a b) (b c)))
                   (graph (set 'a 'b 'c) (make-hash (list (cons 'a (set 'b)) (cons 'b (set 'c))))))

     (check-equal? (make-graph '((a b) (b c) (c a)))
                   (graph (set 'a 'b 'c) (make-hash (list (cons 'a (set 'b)) (cons 'b (set 'c)) (cons 'c (set 'a))))))
     
     (check-equal? (make-graph '((a b) (b a) (b c) (c b) (a c) (c a)))
                   (graph (set 'a 'b 'c) (make-hash (list (cons 'a (set 'b 'c)) (cons 'b (set 'a 'c)) (cons 'c (set 'a 'b))))))

     (check-equal? (make-graph '())
                   (graph (set) (make-hash (list))))

     (check-equal? (make-graph '() #:isolated '(a b))
                   (graph (set 'a 'b) (make-hash (list))))

     (check-equal? (make-graph '((a b) (c b)) #:isolated '(d))
                   (graph (set 'a 'b 'c 'd) (make-hash (list (cons 'a (set 'b)) (cons 'c (set 'b))))))))

  (run-tests make-graph-tests))
