#lang br/quicklang

(define-macro (aoclop-module-begin (aoclop-program BODY))
  #'(#%module-begin
     BODY))
(provide (rename-out [aoclop-module-begin #%module-begin]))

(require 2htdp/batch-io)
(define (read file-number delim)
  (define contents (read-file (string-append (number->string file-number) ".txt")))
  (if (equal? "nl" delim)
      (string-split contents "\n")
      (string-split contents ", ")))
(provide read)

(module+ test
  (require rackunit)
  (check-equal? (read 1 "nl") '("hello" "here" "are" "words")))