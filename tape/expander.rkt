#lang br/quicklang

(provide #%module-begin)
(require threading)
(require "../util.rkt")
(provide read)
(provide delimiter)
(require lens)
(require (for-syntax racket/list racket/syntax racket/match))

(define-syntax-rule (tape-program read (statement-sequence (statement substatement) ...))
  (for/fold ([l read])
            ([transform (list substatement ...)])
    (transform l)))
(provide tape-program)

(define (pointer-assignment target-pos new-val)
  (λ (l) (lens-set (list-ref-lens target-pos) l new-val)))
(provide pointer-assignment)

(define (trace target-pos new-val)
  (λ (l) (begin (displayln target-pos) (displayln new-val))))

(define-syntax (loop stx)
  (syntax-case stx ()
    [(_ identifier-sequence termination-clause read-sequence (statement substatement))
     (with-syntax ([(identifier-sequence id ...) (datum->syntax stx #'identifier-sequence)])
       (with-syntax ([(offset ...) (datum->syntax stx (range (length (syntax->datum #'(id ...)))))])
         #'(λ (input-list) (for/fold ([l input-list])
                                     ([index (range (length input-list))])
                             (begin
                               (define-values (id ...) (values (+ index offset) ...))
                               (substatement l))))))]))
(provide loop)

(tape-program
 (read 2 (delimiter "comma"))
 (statement-sequence
  (statement
   (loop
    (identifier-sequence bar op foo)
    (termination-clause op "=" 99)
    (read-sequence (tape-read 2 temp) (tape-read 4 temptwo))
    (statement (trace op foo))))))