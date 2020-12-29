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

(define-syntax (loop stx)
  (define-values (id-seq term-clause stmt) (match (syntax->datum stx)
                                             [(list _ id-seq term-clause stmt)
                                              (values id-seq term-clause stmt)]))
    

  (define tc (syntax->datum (syntax-case term-clause ()
                              [(_ op = number)
                               #'(= op number)])))
  (display tc)
  
  (define idents (syntax->datum (syntax-case id-seq ()
                                  [(identifier-sequence (identifier ident) ...)
                                   #'(ident ...)])))
  
  (define number-identifiers (length (cdr id-seq)))
  (define indices (for/list ([number (range number-identifiers)])
                    `(list-ref l (+ index ,number))))
  (define let-stmt (for/list ([index indices] [ident idents])
                     `[,ident ,index]))

  #`(λ (input-list) (for/fold ([l input-list])
                              ([index (range 0 (- (length input-list) #,number-identifiers) #,number-identifiers)])
                      (let #,let-stmt (#,stmt l)))))
(provide loop)


(for/fold ([sum 0])
          ([i '(1 2 3 4)])
  #:break (let ([x 4]) (= x i))
  (+ i sum))

(tape-program
 (read 2 (delimiter "comma"))
 (statement (pointer-assignment 1 12))
 (statement (pointer-assignment 2 2))
 (statement
  (loop
   (identifier-sequence (identifier op) (identifier foo) (identifier this-one) (identifier that-one))
   (termination-clause op "=" 99)
   (statement (pointer-assignment op 'hit)))))