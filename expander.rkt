#lang br/quicklang

(define-macro (aoclop-module-begin (aoclop-program BODY ...))
  #'(#%module-begin
     BODY ...))
(provide (rename-out [aoclop-module-begin #%module-begin]))

(require 2htdp/batch-io)
(define (read file-number delim)
  `(read @,file-number @,delim))
(provide read)

(define data empty)

(define (div-each number)
  `(div-each @,number))

(define-macro-cases op
  [(op "/" NUMBER) #'(div-each NUMBER)])
(provide op)

(define-macro-cases delimiter
  [(delimiter "nl") #'"\n"])
(provide delimiter)