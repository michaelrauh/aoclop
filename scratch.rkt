#lang racket

(define-syntax aoclop-program
  (syntax-rules ()
    [(aoclop-program read-expr (scope-block (all-ops operation ...)))
     (map (λ (x) (operations (operation ... x))) read-expr)]))

(define-syntax (operations stx)
  (define lst (syntax->datum stx))
  (define the-data (reverse (cadr lst)))
  (define lambda-x (car the-data))
  (define ops (cdr the-data))
  #`(x-then-ops-in-order(#,lambda-x #,@ops)))

(define-syntax (x-then-ops-in-order stx)
  (define lst (cadr (syntax->datum stx)))
  (define lambda-x (car lst))
  #`(floor #,lambda-x))

(define-syntax-rule (delimiter "nl")
  "\n")

(require 2htdp/batch-io)
(define (read file-number delim)
  (define contents (read-file (string-append (number->string file-number) ".txt")))
  (define strings (string-split contents delim))
  (map string->number strings))
(provide read)

(aoclop-program (read 1 (delimiter "nl")) (scope-block (all-ops (op "floor"))))