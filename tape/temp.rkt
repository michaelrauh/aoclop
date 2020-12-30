#lang racket

;(define-syntax (statement stx)
;  (syntax-case stx ()
;    [(_ operation)
;     #`(let ([op 3]) #,operation)]))


(define-syntax (statement stx)
  (syntax-case stx ()
    [(_ operation)
     (with-syntax ([op (datum->syntax stx 'op)])
       #'(let ([op 3]) operation))]))
(statement (+ 1 op))

;(syntax-case stx ()
;       (with-syntax ([(op ...) (map (lambda (op) (datum->syntax stx op)) 
;                                     (syntax->list #'(op ...)))])
;          #'(let ([op 3] ...)
;               operation)))

; Actually, instead of syntax->list, you should use '(op op2 op3) directly