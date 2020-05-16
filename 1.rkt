#lang racket
(require 2htdp/batch-io)
(define (read-split file-name [delim #rx", "])
  (define contents (read-file file-name))
  (string-split contents delim))

(module+ test
  (require rackunit)
  (check-equal? (read-split "1.txt") '("hello" "here" "are" "words")))