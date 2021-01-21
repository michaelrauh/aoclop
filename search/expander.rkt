#lang br/quicklang

(provide #%module-begin)
(require (for-syntax racket/string))

(define-syntax (search-program stx)
  (syntax-case stx ()
    [(_ find-block satisfying-block return-block)
     (with-syntax* ([(_ (_ (_ ident search-space) ...)) #'find-block]
                    [(satisfying-block call import target) #'satisfying-block]
                    [new-call (datum->syntax stx #'call)]
                    [(_ func _ _) #'new-call]
                    [import (datum->syntax stx #'(import-file import func))])
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
    [(_ str func) (with-syntax (
                    [filename (datum->syntax stx (string-replace (symbol->string (syntax->datum #'str)) "file_" ""))])
       #'(require (rename-in filename (func func))))]))

(define-syntax-rule (return-block expression)
  expression)
(provide return-block)

(define-syntax-rule (expression lhs operation rhs)
  (operation lhs rhs))
(provide expression)

(define-syntax (operator stx)
  (syntax-case stx ()
    [(_ "+") #'+]
    [(_ "*") #'*]))
(provide operator)

(define-syntax-rule (function-call func first second)
  (func first second))
(provide function-call)
