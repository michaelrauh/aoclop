#lang br/quicklang
(require "parser.rkt" "tokenizer.rkt")

(define (read-syntax path port)
  (define parse-tree (parse path (make-tokenizer port path)))
  (strip-bindings
   #`(module search-mod search/expander
       #,parse-tree)))

(module+ reader
  (provide read-syntax))
