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

(define-syntax (tape-read-l stx)
  (syntax-case stx ()
    [(_ (tape-read from to) l)
    #'(define to (list-ref l from))]
    [(_ (tape-read from to) next l)
     #'(begin
       (define to (list-ref l from))
       (tape-read-l next l))]))

(define-syntax (loop stx)
  (define-values (id-seq term-clause read-seq stmt) (match (syntax->datum stx)
                                             [(list _ id-seq term-clause read-seq stmt)
                                              (values id-seq term-clause read-seq stmt)]))
    

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
                      (let #,let-stmt (begin (tape-read-l #,@read-seq l) (#,stmt l))))))
(provide loop)