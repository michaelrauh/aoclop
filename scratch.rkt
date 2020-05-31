#lang racket

(define-syntax-rule (aoclop-program read-expr (scope-block (all-ops operation ...)))
  (map (λ (x) (operations (operation ... x))) read-expr))

(define-syntax (operations stx)
  (define lst (syntax->datum stx))
  (define the-data (reverse (cadr lst)))
  (define lambda-x (car the-data))
  (define ops (cdr the-data))
  (datum->syntax stx `(x-then-ops-in-order(,lambda-x ,@ops))))

(define-syntax (x-then-ops-in-order stx)
  (define lst (cadr (syntax->datum stx)))
  (define lambda-x-datum (car lst))
  (define cur-op-datum (cadr lst))
  (define len (length (cdr lst)))
  (cond
    [(and (> len 1) (eq? "add1" (cadr cur-op-datum))) (datum->syntax stx `(add1 (x-then-ops-in-order(,lambda-x-datum ,@(cdr (cdr lst))))))]
    [(eq? "add1" (cadr cur-op-datum)) (datum->syntax stx `(add1 ,lambda-x-datum))]
    [(eq? "floor" (cadr cur-op-datum)) (datum->syntax stx `(floor ,lambda-x-datum))]))

(define-syntax-rule (delimiter "nl")
  "\n")

(require 2htdp/batch-io)
(define (read file-number delim)
  (define contents (read-file (string-append (number->string file-number) ".txt")))
  (define strings (string-split contents delim))
  (map string->number strings))
(provide read)

(aoclop-program (read 1 (delimiter "nl")) (scope-block (all-ops (op "floor") (op "add1"))))