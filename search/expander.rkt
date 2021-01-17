#lang br/quicklang

(provide #%module-begin)
(require threading)
(require "../util.rkt")
(provide read)
(provide delimiter)
(require lens)
(require (for-syntax racket/list racket/syntax racket/match))

(define-syntax (tape-program stx)
  (syntax-case stx ()
    [(_ read (statement-sequence (statement substatement) ...))
     #'(begin
         (list-ref 
          (for/fold ([l read])
                    ([transform (list substatement ...)])
            (transform l)) 0))]
    [(_ (input arg ...) read (statement-sequence (statement substatement) ...))
     #'(begin (define tape (λ (arg ...)
                             (begin
                               (list-ref 
                                (for/fold ([l read])
                                          ([transform (list substatement ...)])
                                  (transform l)) 0))))
              (provide tape))]))
(provide tape-program)

(define (pointer-assignment target-pos new-val)
  (λ (l) (lens-set (list-ref-lens target-pos) l new-val)))
(provide pointer-assignment)

(define-syntax-rule (process-read l (delegate first second))
  (delegate l first second))

(define-syntax-rule (assignment l target value)
  (define target value))
(provide assignment)

(define-syntax-rule (tape-read l index target)
  (define target (list-ref l index)))
(provide tape-read)

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

(define-syntax-rule (case-select to-find hashmap)
  (hash-ref hashmap to-find))
(provide case-select)

(define-syntax-rule (hashmap entry ...)
  (hash entry ...))
(provide hashmap)

(define-syntax (operator stx)
  (syntax-case stx ()
    [(_ "+") #'+]
    [(_ "*") #'*]))
(provide operator)

(define-syntax-rule (evaluation x op y)
  (op x y))
(provide evaluation)