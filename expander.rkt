#lang br/quicklang

(define-macro (aoclop-module-begin (aoclop-program READ (op FUNC ...) OPS ...))
  #'(#%module-begin
     (op FUNC ... READ OPS ...)))
(provide (rename-out [aoclop-module-begin #%module-begin]))

(require 2htdp/batch-io)
(define (read file-number delim)
  (define contents (read-file (string-append (number->string file-number) ".txt")))
  (string-split contents delim))
(provide read)

(define-macro-cases op
  [(op "/" NUMBER READ-EXPR) #'(map (λ (x) (/ (string->number x) NUMBER)) READ-EXPR)]
  [(op "floor" READ-EXPR) #'(map (λ (x) (floor (string->number x))) READ-EXPR)]
  [(op "/" NUMBER READ-EXPR (op "floor")) #'(map (λ (x) (floor (/ (string->number x) NUMBER))) READ-EXPR)]
  [(op "floor" READ-EXPR (op "/" NUMBER)) #'(map (λ (x) (/ (floor (string->number x)) NUMBER)) READ-EXPR)])
(provide op)

(define-macro-cases delimiter
  [(delimiter "nl") #'"\n"])
(provide delimiter)