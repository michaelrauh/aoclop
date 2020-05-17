#lang racket
(require 2htdp/batch-io)
(define (read-split file-name delim)
  (define contents (read-file file-name))
  (string-split contents delim))

(module+ test
  (require rackunit)
  (check-equal? (read-split "1.txt" #rx", ") '("hello" "here" "are" "words")))