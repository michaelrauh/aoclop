#lang racket

(require (for-syntax syntax/parse))
(require 2htdp/batch-io)
(define (read file-number delim)
  (define contents (read-file (string-append (number->string file-number) ".txt")))
  (define strings (string-split contents delim))
  strings)
(provide read)
(require (for-syntax racket/list syntax/parse))

; issues:
; 1. If it is an integer it has to be cast to that. There is no syntax for that.
; 2. The current read method assumes integers and this prompt requires strings.
; 3. long term concern - is it OK for the semantics of this langs read method to be string based? Or does there need to be syntax for that?


(define-syntax (binding-set stx)
  (define-syntax-class many-idents
    #:datum-literals (identifier-sequence)
    (pattern (_ ident ... ident-l)
             #:with step (datum->syntax stx (length (syntax->datum #'(ident ...))))
             #:with (offset ...) (datum->syntax stx (range (syntax->datum #'step)))))
  (define-syntax-class gen-data
    #:datum-literals (expression)
    (pattern (expression expr)))
  
  (syntax-parse stx
    [(_ id-seq:many-idents gen-expr:gen-data)
     #'(for ([id-seq.ident (list (substring gen-expr.expr id-seq.offset (+ 1 id-seq.offset)))] ... [id-seq.ident-l (list (substring gen-expr.expr id-seq.step))])
         (displayln (list id-seq.ident ... id-seq.ident-l)))]))

(binding-set (identifier-sequence one two three) (expression "abcd"))
(binding-set (identifier-sequence four) (expression "abcd"))
