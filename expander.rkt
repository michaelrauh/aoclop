#lang br/quicklang

(define-macro (aoclop-module-begin (aoclop-program READ (scope-block OP)))
  #'(#%module-begin
     (scope-block OP READ)))
(provide (rename-out [aoclop-module-begin #%module-begin]))

(define-macro (scope-block OP READ)
  #'(map (λ (x) (ops OP x)) READ))
(provide scope-block)

(define-macro (ops (op "floor") X)
  #'(floor X))

(define-macro-cases delimiter
  [(delimiter "nl") #'"\n"])
(provide delimiter)

(require 2htdp/batch-io)
(define (read file-number delim)
  (define contents (read-file (string-append (number->string file-number) ".txt")))
  (define strings (string-split contents delim))
  (map string->number strings))
(provide read)