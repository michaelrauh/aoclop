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

(define-syntax (loop stx)
  (define datum (syntax->datum stx))
  (define loop (car datum))
  (define ids (car (cdr datum)))
  (define terms (car (cdr (cdr datum))))
  (define statement (car (cdr (cdr (cdr datum)))))
  (define ctx (datum->syntax stx '(define op 5)))
  (define stmt (datum->syntax ctx statement))
  (display stmt)
  #'(λ (x) x))
(provide loop)

(tape-program
    (read 2 (delimiter "comma"))
    (statement (pointer-assignment 1 12))
    (statement (pointer-assignment 2 2))
    (statement
     (loop
      (identifier-sequence (identifier op))
      (termination-clause op "=" 99)
      (statement (pointer-assignment op 'hit)))))