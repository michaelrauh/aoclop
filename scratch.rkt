#lang racket

(define-syntax-rule (aoclop-program read-expr (scope-block (all-ops operation ...)))
  (map (λ (x) (operations (operation ... x))) read-expr))

(define-syntax (operations stx)
  (define lst (syntax->datum stx))
  (define the-data (reverse (cadr lst)))
  (define lambda-x (car the-data))
  (define ops (cdr the-data))
  (datum->syntax stx `(x-then-ops-in-order(,lambda-x ,ops))))

(define-syntax (x-then-ops-in-order stx)
  (syntax-case stx ()
    [(_ (lambda-x (ops ...))) (syntax-case #'(ops ...) ()
                              [((_ "add1")) #'(add1 lambda-x)]
                                [((_ "floor")) #'(floor lambda-x)]
                                [((_ "add1") otherop ...) #'(add1 (x-then-ops-in-order(lambda-x (otherop ...))))]
                                [((_ "floor") otherop ...) #'(floor (x-then-ops-in-order(lambda-x (otherop ...))))])]))


(define-syntax-rule (delimiter "nl")
  "\n")

(require 2htdp/batch-io)
(define (read file-number delim)
  (define contents (read-file (string-append (number->string file-number) ".txt")))
  (define strings (string-split contents delim))
  (map string->number strings))
(provide read)

(aoclop-program (read 1 (delimiter "nl")) (scope-block (all-ops (op "add1") (op "floor") (op "add1"))))