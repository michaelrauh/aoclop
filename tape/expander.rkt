#lang br/quicklang

(provide #%module-begin)
(require threading)
(require "../util.rkt")
(provide read)
(provide delimiter)
(require lens)
(require (for-syntax racket/list racket/syntax syntax/parse))

(define-syntax (tape-program stx)
  (syntax-parse stx
    #:datum-literals (tape-program input statement-sequence statement)
    [(tape-program read:expr (statement-sequence (statement substatement:expr) ...))
     #'(begin
         (list-ref 
          (for/fold ([l read])
                    ([transform (list substatement ...)])
            (transform l)) 0))]
    [(tape-program (input arg ...) read:expr (statement-sequence (statement substatement:expr) ...))
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
  (define-syntax-class id-seq
    #:description "a sequence of identifiers"
    #:datum-literals (identifier-sequence)
    (pattern (identifier-sequence id ...)
             #:with step (datum->syntax stx (length (syntax->datum #'(id ...))))
             #:with (offset ...) (datum->syntax stx (range (syntax->datum #'step)))))
  
  (syntax-parse stx
    #:datum-literals (statement read-sequence)
    [(_ identifier-sequence:id-seq termination-clause:expr (read-sequence read-clause:expr ...) (statement substatement:expr))
       #'(λ (input-list) (for/fold ([l input-list])
                                   ([index (range 0 (- (length input-list) identifier-sequence.step) identifier-sequence.step)])
                           #:break (let-values ([(identifier-sequence.id ...) (values (list-ref l (+ index identifier-sequence.offset)) ...)])
                                     termination-clause)
                           (let-values ([(identifier-sequence.id ...) (values (list-ref l (+ index identifier-sequence.offset)) ...)])
                             (begin
                               (process-read l read-clause) ...
                               (substatement l)))))]))
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