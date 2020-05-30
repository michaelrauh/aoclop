#lang racket

(define-syntax-rule (aoclop-program read-block (scope-block (all-ops op)))
  (map (λ (x) (op-expr x)) '(1.2 2.3 3)))

(define-syntax (op-expr stx)
  (define x (car (cdr (syntax->datum stx))))
  (define thing (datum->syntax stx x))
  #`(floor #,thing))

(aoclop-program (read 1 (delimiter "nl")) (scope-block (all-ops (op "floor"))))