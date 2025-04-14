#lang racket

;; Fermat's little theorem!

;; reading:
;; Algorithms by S. Dasgupta, C.H. Papadimitriou, and U.V. Vazirani
;; 1.3 Primality testing

;; but the code is only implementation and has little to do with the book IMO

(require "../../../util/racket/macros.rkt")

(provide prime?)

(module+ test
  (require rackunit rackunit/text-ui))

(define big-mod 1000000007)

;; exponentiation by squaring with modulo
;; x to the power of y (mod n)
(define (expt/remainder x y [n big-mod])
  (if (< y 1)
      1
      (--> (* (if (odd? y) x 1)
              (expt/remainder (--> (* x x) (remainder n)) (arithmetic-shift y -1) n))
           (remainder n))))

(module+ test
  (define expt/remainder-tests
    (test-suite
     "expt/remainder"
     (test-case
         "zero or one"
       (check-equal? (expt 0 1) (expt/remainder 0 1))
       (check-equal? (expt 1 0) (expt/remainder 1 0))
       (check-equal? (expt 1 300) (expt/remainder 1 300))
       (check-equal? (expt 0 0) (expt/remainder 0 0)))
     (test-case
         "small"
       (check-equal? (expt 3 4) (expt/remainder 3 4))
       (check-equal? (expt 3 5) (expt/remainder 3 5))
       (check-equal? (expt 3 6) (expt/remainder 3 6))
       (check-equal? (remainder (expt 3 6) 83) (expt/remainder 3 6 83)))
     (test-case
         "big"
       (check-equal? (remainder (expt 10 10) big-mod) (expt/remainder 10 10))
       ;; I wonder why these big number operations are possible
       (check-equal? (remainder (expt 500 20) big-mod) (expt/remainder 500 20))
       (check-equal? (remainder (expt 20 40) big-mod) (expt/remainder 20 40))))))

;; randomized test according to Fermat's little theorem
(define (prime? n [default #f])
  (define a (or default (random 2 n)))
  (= 1 (expt/remainder a (sub1 n) n)))

(module+ test
  (define prime?-tests
    (test-suite
     "prime?"
     (test-case
         "simple"
       (check-true (prime? 3 2))
       (check-false (prime? 4 2))
       (check-false (prime? 4 3))
       (check-true (prime? 5 2))
       (check-true (prime? 5 3))
       (check-true (prime? 5 4)))
     (test-case
         "edge"
       (check-true (prime? 4 1) "1 is always true")
       (check-true (prime? 341 2) "Carmichael number")))))

;; You might want to check out factor.c in coreutils for more primality tests in real world!
;; https://git.savannah.gnu.org/cgit/coreutils.git/tree/src/factor.c

(module+ test
  (run-tests (test-suite "all"
                         expt/remainder-tests
                         prime?-tests)))
