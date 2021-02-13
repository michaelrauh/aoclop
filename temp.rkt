#lang racket

(require (for-syntax syntax/parse))
(require 2htdp/batch-io)
(define (read file-number delim)
  (define contents (read-file (string-append (number->string file-number) ".txt")))
  (define strings (string-split contents delim))
  strings)
(provide read)
(require (for-syntax racket/list syntax/parse))

;(define-syntax (delimiter stx)
;  (syntax-case stx ()
;    [(delimiter "newline") #'"\n"]
;    [(delimiter "comma") #'","]))
;(provide delimiter)

;(define data (read 3 "\n"))
;(for ([big-string data])
;  (for ([obj (string-split big-string ",")])
;    (begin
;      (displayln (substring obj 0 1))
;    (displayln (substring obj 1)))))

; issues:
; 1. for the last substring, don't include the end of the interval.
; 2. If it is an integer it has to be cast to that. There is no syntax for that.
; 3. The current read method assumes integers and this prompt requires strings.
; 4. Helpers work and are shown below.
; 5. long term concern - is it OK for the semantics of this langs read method to be string based? Or does there need to be syntax for that?

;(define-syntax (test stx)
;  (syntax-parse stx
;    [(_ body ...)
;     (process-body 
;      stx)]))

;(define-for-syntax (process-body stx)
;  (syntax-parse stx
;    [(_ foo ...) #'(display foo ...)]))

  ;(test (+ 1 2))

;(binding-set (identifier-sequence wire) (expression (list 1 2 3 4 5)))


(define-syntax (binding-set stx)
  (define-syntax-class one-ident
    #:datum-literals (identifier-sequence)
    (pattern (_ ident)))
  (define-syntax-class many-idents
    #:datum-literals (identifier-sequence)
    (pattern (_ ident ... ident-l)
             #:with step (datum->syntax stx (length (syntax->datum #'(ident ...))))
             #:with (offset ...) (datum->syntax stx (range (syntax->datum #'step)))))
  (define-syntax-class gen-data
    #:datum-literals (expression)
    (pattern (expression expr)))
  (syntax-parse stx
    [(_ id-seq:one-ident gen-expr:gen-data)
     #'(define id-seq.ident gen-expr.expr)]
    [(_ id-seq:many-idents gen-expr:gen-data)
     #'(begin (define id-seq.ident (substring gen-expr.expr id-seq.offset (+ 1 id-seq.offset))) ... (define id-seq.ident-l (substring gen-expr.expr id-seq.step)))]))

(binding-set (identifier-sequence wire two other) (expression "abcd"))
(binding-set (identifier-sequence three) (expression "abcd"))