#lang racket/base

(provide ->> --> as->
         $ cut λx
         &)

(require (for-syntax racket/base)
         (for-syntax syntax/parse))

(module+ test
  (require rackunit rackunit/text-ui
           syntax/macro-testing))

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
     (check-equal? (--> 5 (- 2)) 3))))

;; Clojure `->>` thread last
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
     (check-equal? (->> 5 (- 2)) -3))))

;; Clojure `as->`
(define-syntax (as-> stx)
  (syntax-parse stx
    [(_ init:expr bind:id) #'init]
    [(_ acc:expr bind:id arg:expr args:expr ...)
     #'(let ([bind acc]) (as-> arg bind args ...))]))

(module+ test
  (define as->tests
    (test-suite
     "as->"
     (check-equal? (as-> 3 n (+ n 2) (- n 3) (- 5 n)) 3)
     (check-equal? (as-> '(((hello . ok))) d (car d) (assq 'hello d) (cdr d)) 'ok))))

;; Gauche `$`
(define-syntax ($ stx)
  (datum->syntax stx
                 (let loop ([l (cdr (syntax->datum stx))])
                   (cond [(null? l)        '()]
                         [(eq? '$ (car l)) `(,(loop (cdr l)))]
                         [else             (cons (car l) (loop (cdr l)))]))))

(module+ test
  (define $-tests
    (test-suite
     "$"
     (check-equal? ($ list->string $ reverse $ string->list "mom olleh") "hello mom"))))

;; Gauche `cut`
(define-syntax (cut stx)
  (define (make-var cnt) (string->symbol (string-append "x" (number->string cnt))))
  
  (define-values (l cnt)
    (for/fold ([acc '()] [cnt 0] #:result (values (reverse acc) cnt))
              ([x (in-list (cdr (syntax->datum stx)))])
      (if (eq? '<> x)                   ; Gauche doesn't look through inside nested lists, too
          (values (cons (make-var cnt) acc) (add1 cnt))
          (values (cons x acc) cnt))))
  
  (define args (for/list ([i (in-range cnt)]) (make-var i)))
  
  (datum->syntax stx
                 `(lambda ,args ,l)))

(module+ test
  (define cut-tests
    (test-suite
     "cut"
     (test-case
         "valid"
       (check-true ((cut < <> <> <>) 10 11 12))
       (check-equal? ((cut + 12 30)) 42))
     (test-case
         "invalid"
       (check-exn exn:fail?
                  (λ () ((cut (cut <>)))))))))

;; like Gauche's ^x, may look better than (λ (x) ...)
(define-syntax (λx stx)
  (datum->syntax stx `(lambda (x) ,@(cdr (syntax->datum stx)))))

(module+ test
  (define λx-tests
    (test-suite
     "λx"
     (check-equal? ((λx (* (+ x 12) x)) 4) 64))))

;; Elixir fn shorthand &(&1 + &2)
;; - nested & is error
;; - traverses deeply as opposed to cut
;; - does not complain about skipping arguments as opposed to Elixir
(define-syntax (& stx)
  (define (arg-spec? str)
    (and (string=? "&" (substring str 0 1))
         (let* ([sub (substring str 1)]
                [d (string->number sub)])
           (and d                                     ; parsed
                (positive? d)                         ; shoould be greater than 0
                (not (char=? #\0 (string-ref sub 0))) ; no leading zero
                ))))
  
  ;; str is arg-spec?
  (define (arg-number str)
    (define sub (substring str 1))
    (string->number sub))
  
  (define (make-var n) (string->symbol (string-append "&" (number->string n))))
  
  (define-values (l cnt)
    (let loop ([lst (cdr (syntax->datum stx))])
      (for/fold ([acc '()] [cnt 0] #:result (values (reverse acc) cnt))
                ([x (in-list lst)])
        (cond [(list? x)
               (define-values (res-lst res-cnt) (loop x))
               (values (cons res-lst acc) (max cnt res-cnt))]
              [(equal? '& x)
               (raise-syntax-error #f "nested & is not allowed" stx)]
              [else
               (define str (symbol->string x))
               (define next-acc (cons x acc))
               (if (arg-spec? str)
                   (values next-acc (max cnt (arg-number str)))
                   (values next-acc cnt))]))))
  
  (define args (for/list ([i (in-inclusive-range 1 cnt)]) (make-var i)))

  (datum->syntax stx
                 `(lambda ,args ,@l)))

(module+ test
  (define &-tests
    (test-suite
     "&"
     (test-case
         "valid"
       (check-equal? (procedure-arity (& (+ &1 &2))) 2)
       (check-equal? (procedure-arity (& (+ &4))) 4)
       (check-equal? ((& (+ &1 &2)) 3 5) 8)
       (check-equal? ((& (+ &4)) -1 -2 -3 4) 4)
       (check-equal? ((& (+ (- &1 &2) &3)) 5 9 4) 0))
     (test-case
         "invalid"
       (check-exn exn:fail:syntax?
                  (λ () (convert-compile-time-error (& (& (+ &1))))))
       (check-exn exn:fail:syntax?
                  (λ () (convert-compile-time-error (& &))))))))

(module+ test
  (run-tests
   (test-suite "all"
               -->-tests ->>-tests as->tests
               $-tests cut-tests λx-tests
               &-tests)))
