#lang br/quicklang

(define-macro (aoclop-module-begin (aoclop-program BODY ...))
  #'(#%module-begin
     BODY ...))
(provide (rename-out [aoclop-module-begin #%module-begin]))

(require 2htdp/batch-io)
(define (read file-number delim)
  (define contents (read-file (string-append (number->string file-number) ".txt")))
  (set! data (string-split contents delim)))
(provide read)

(define data empty)

(define-macro-cases op
  [(op "/" NUMBER) #'(map (λ (x) (/ (string->number x) NUMBER)) data)])
(provide op)

(define-macro-cases delimiter
  [(delimiter "nl") #'"\n"])
(provide delimiter)