#lang br/quicklang

(provide #%module-begin)
(require threading)
(require "../util.rkt")
(provide read)
(provide delimiter)
(require lens)
(require (for-syntax racket/list racket/syntax racket/match))

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

(define-syntax-rule (tape-read-l (tape-read from to) l)
  (define to (list-ref l from)))

(define-syntax (loop stx)
  (define-values (id-seq term-clause tape-read stmt) (match (syntax->datum stx)
                                             [(list _ id-seq term-clause tape-read stmt)
                                              (values id-seq term-clause tape-read stmt)]))
    

  (define tc (syntax->datum (syntax-case term-clause ()
                              [(_ op "=" number)
                               #'(= op number)])))
  
  (define idents (syntax->datum (syntax-case id-seq ()
                                  [(identifier-sequence ident ...)
                                   #'(ident ...)])))
  
  (define number-identifiers (length idents))
  (define indices (for/list ([number (range number-identifiers)])
                    `(list-ref l (+ index ,number))))
  (define let-stmt (for/list ([index indices] [ident idents])
                     `[,ident ,index]))

  #`(λ (input-list) (for/fold ([l input-list])
                              ([index (range 0 (- (length input-list) #,number-identifiers) #,number-identifiers)])
                      #:break (let #,let-stmt #,tc)
                      (let #,let-stmt (begin (tape-read-l #,tape-read l) (#,stmt l))))))
(provide loop)