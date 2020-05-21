#lang br/quicklang

(define-macro (aoclop-module-begin (aoclop-program READ OP))
  #'(#%module-begin
     (map (λ (x) OP) READ)))
(provide (rename-out [aoclop-module-begin #%module-begin]))

(require 2htdp/batch-io)
(define (read file-number delim)
  (define contents (read-file (string-append (number->string file-number) ".txt")))
  (string-split contents delim))
(provide read)

(define data empty)

(define (div number)
  (/ x number))

(define-macro-cases op
  [(op "/" NUMBER) #'(div NUMBER)])
(provide op)

(define-macro-cases delimiter
  [(delimiter "nl") #'"\n"])
(provide delimiter)