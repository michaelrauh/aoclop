#lang br/quicklang

(provide #%module-begin)
(require threading)
(require "../util.rkt")
(provide read)
(provide delimiter)
(require lens)

(define-syntax-rule (tape-program read statement ...)
  (for/fold ([l read])
          ([transform (list statement ...)])
  (transform l)))
(provide tape-program)

(define-syntax-rule (statement substatement) substatement)
(provide statement)

(define (pointer-assignment target-pos new-val)
 (λ (l) (lens-set (list-ref-lens target-pos) l new-val)))
(provide pointer-assignment)