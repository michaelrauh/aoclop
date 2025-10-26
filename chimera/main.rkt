#lang br/quicklang
(require "parser.rkt" "tokenizer.rkt")

(define (read-syntax path port)
  (define parse-tree (parse path (make-tokenizer port path)))
  (println parse-tree)
  (strip-bindings
   #`(module chimera-mod chimera/expander
       #,parse-tree)))

(module+ reader
  (provide read-syntax))