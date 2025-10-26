#lang racket

(require 2htdp/batch-io)
(define (read file-number delim)
  (define contents (read-file (string-append (number->string file-number) ".txt")))
  (define strings (string-split contents delim))
  (map string->number strings))
(provide read)

(define (read-string file-number delim)
  (define contents (read-file (string-append (number->string file-number) ".txt")))
  (define strings (string-split contents delim))
  strings)
(provide read-string)

(define-syntax (delimiter stx)
  (syntax-case stx ()
    [(delimiter "nl") #'"\n"]
    [(delimiter "comma") #'","]
    [(delimiter "newline") #'"\n"]))
(provide delimiter)

(define-syntax (operator stx)
  (syntax-case stx ()
    [(_ "+") #'+]
    [(_ "*") #'*]))
(provide operator)