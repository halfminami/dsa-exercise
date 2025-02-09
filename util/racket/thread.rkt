#lang racket/base

(provide ->> -->)

(module+ test
  (require rackunit rackunit/text-ui))

;; Clojure `->` thread macro!
(define-syntax -->
  (syntax-rules ()
    [(_ init) init]
    [(_ acc (f args ...) rst ...) (--> (f acc args ...) rst ...)]
    [(_ acc f rst ...) (--> (f acc) rst ...)]))

(module+ test
  (define -->-tests
    (test-suite
     "-->"
     (check-true (--> 3 add1 (add1) (= 5)))
     (check-equal? 3 (--> 5 (- 2))))))

;; `->>` thread last
(define-syntax ->>
  (syntax-rules ()
    [(_ init) init]
    [(_ acc (f args ...) rst ...) (->> (f args ... acc) rst ...)]
    [(_ acc f rst ...) (->> (f acc) rst ...)]))

(module+ test
  (define ->>-tests
    (test-suite
     "->>"
     (check-true (->> 3 add1 (add1) (= 5)))
     (check-equal? -3 (->> 5 (- 2))))))

(module+ test
  (run-tests (test-suite "all" -->-tests ->>-tests)))
