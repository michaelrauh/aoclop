#lang br/quicklang

(define-macro (aoclop-module-begin (aoclop-program BODY ...))
  #'(#%module-begin
     BODY ...
     (display data)))
(provide (rename-out [aoclop-module-begin #%module-begin]))

(require 2htdp/batch-io)
(define (read file-number delim)
  (define contents (read-file (string-append (number->string file-number) ".txt")))
  (set! data (string-split contents delim)))
(provide read)

(define data empty)

(define (div-each number)
  (define (divnum x) (/ (string->number x) number))
  (define ans (map divnum data))
  (set! data ans))

(define-macro-cases op
  [(op "/" NUMBER) #'(div-each NUMBER)])
(provide op)

(define-macro-cases delimiter
  [(delimiter "nl") #'"\n"])
(provide delimiter)