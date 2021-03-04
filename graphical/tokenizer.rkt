#lang br
(require "lexer.rkt" brag/support)

(define (make-tokenizer ip [path #f])
  (port-count-lines! ip)
  (lexer-file-path path)
  (define (next-token) (aoclop-lexer ip))
  next-token)
(provide make-tokenizer)