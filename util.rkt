#lang racket

(require 2htdp/batch-io)
(define (read file-number delim)
  (define contents (read-file (string-append (number->string file-number) ".txt")))
  (define strings (string-split contents delim))
  (map string->number strings))
(provide read)

(define-syntax (delimiter stx)
  (syntax-case stx ()
    [(delimiter "nl") #'"\n"]
    [(delimiter "comma") #'","]))
(provide delimiter)