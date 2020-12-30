#lang br/quicklang

(define-syntax-rule (program subprogram)
  subprogram)

(define-syntax (statement stx)
  #`(let ([op 3]) #,(car (cdr (syntax->datum stx)))))

(program (statement (+ 1 op)))
