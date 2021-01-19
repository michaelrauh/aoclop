#lang br/quicklang

(provide #%module-begin)
(require (for-syntax racket/string))

(define-syntax (search-program stx)
  (syntax-case stx ()
    [(_ find-block satisfying-block return-block)
     (with-syntax* ([(_ (_ (_ ident search-space) ...)) #'find-block]
                    [(satisfying-block call import target) #'satisfying-block]
                    [new-call (datum->syntax stx #'call)]
                    [import (datum->syntax stx #'(import-file import))])
       #'(begin
           import
           (for*/first ([ident search-space] ...
              #:when (eq? new-call target))
             return-block)))]))
(provide search-program)

(define-syntax-rule (range-expr start end)
  (in-range start end))
(provide range-expr)

(define-syntax (import-file stx)
  (syntax-case stx ()
    [(_ str) (with-syntax (
                    [filename (datum->syntax stx (string-replace (symbol->string (syntax->datum #'str)) "file_" ""))])
       #'(require filename))]))

(define-syntax-rule (return-block expression)
  expression)

(define-syntax-rule (expression lhs operation rhs)
  (operation lhs rhs))

(define-syntax (operator stx)
  (syntax-case stx ()
    [(_ "+") #'+]
    [(_ "*") #'*]))


(define-syntax-rule (function-call func first second)
  (func first second))
(provide function-call)

;(search-program
;    (find-block
;     (assignment-sequence
;      (assignment noun (range-expr 0 100))
;      (assignment verb (range-expr 0 100))))
;    (satisfying-block (function-call tape noun verb) file_2.2_tape.rkt 19690720)
;    (return-block
;     (expression (expression noun (operator "*") 100) (operator "+") verb)))

;(define-syntax-rule (foo)
;  (begin
;    (require "2.2_tape.rkt")
;    (tape 1 2)))
;(foo)

(import-file file_2.2_tape.rkt)
tape