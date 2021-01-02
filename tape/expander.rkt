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

(define-syntax-rule (process-read l (tape-read index target))
  (define target (list-ref l index)))

(define-syntax (termination-clause stx)
  (syntax-case stx ()
    [(_ comp1 "=" comp2)
     #'(= comp1 comp2)]))
(provide termination-clause)

(define-syntax (loop stx)
  (syntax-case stx ()
    [(_ identifier-sequence termination-clause read-sequence (statement substatement))
     (with-syntax* (
                    [(identifier-sequence id ...) (datum->syntax stx #'identifier-sequence)]
                    [step (length (syntax->datum #'(id ...)))]
                    [(offset ...) (datum->syntax stx (range (syntax->datum #'step)))]
                    [termination_clause (datum->syntax stx #'termination-clause)]
                    [(_ read-clause ...) (datum->syntax stx #'read-sequence)])
       #'(λ (input-list) (for/fold ([l input-list])
                                   ([index (range 0 (- (length input-list) step) step)])
                           #:break (let-values ([(id ...) (values (list-ref l (+ index offset)) ...)])
                                     termination_clause)
                           (let-values ([(id ...) (values (list-ref l (+ index offset)) ...)])
                             (begin
                               (process-read l read-clause) ...
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
    (statement (pointer-assignment temp op))))))