#lang br/quicklang

(provide #%module-begin)
(require (for-syntax racket/string syntax/parse))


(define-syntax (search-program stx)
  (define-syntax-class find-statement
    #:description "a find block"
    #:datum-literals (find-block assignment-sequence assignment)
    (pattern (find-block (assignment-sequence (assignment ident:id space:expr) ...))))

  (define-syntax-class satisfying-routine
    #:description "a satisfying block"
    #:datum-literals (satisfying-block function-call)
    (pattern (satisfying-block call:expr imp:id target:number)
             #:with (function-call func _ ...) #'call
             #:with import (datum->syntax stx #'(import-file imp func))))
  
  (syntax-parse stx
    [(search-program assignment:find-statement routine:satisfying-routine return-block:expr)
       #'(begin
           routine.import
           (for*/first ([assignment.ident assignment.space] ...
              #:when (eq? routine.call routine.target))
             return-block))]))
(provide search-program)


(define-syntax (import-file stx)
  (syntax-case stx ()
    [(_ str func) (with-syntax (
                    [filename (datum->syntax stx (string-replace (symbol->string (syntax->datum #'str)) "file_" ""))])
       #'(require (rename-in filename (func func))))]))
(provide import-file)

(define-syntax-rule (range-expr start end)
  (in-range start end))
(provide range-expr)

(define-syntax-rule (return-block expression)
  expression)
(provide return-block)

(define-syntax-rule (expression lhs operation rhs)
  (operation lhs rhs))
(provide expression)

(define-syntax (operator stx)
  (syntax-parse stx
    #:datum-literals (operator)
    [(operator "+") #'+]
    [(operator "*") #'*]))
(provide operator)

(define-syntax-rule (function-call func first second)
  (func first second))
(provide function-call)
