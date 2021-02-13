#lang br/quicklang

(provide #%module-begin)
(require threading)
(require "../util.rkt")
(provide read)
(provide delimiter)

(require(for-syntax syntax/parse))

(define-syntax-rule (graphical-program (expression-sequence expr ...))
  (expr ...))

(define-syntax-rule (expression subexpr)
  subexpr)

(define-for-syntax (process-split stx)
  stx)

(define-syntax (loop stx)
  (define-syntax-class expr-seq
    #:description "a sequence of expressions"
    #:datum-literals (expression-sequence)
    (pattern (expression-sequence expr:expr ...)))
  
  (define-syntax-class bind-set
    #:description "bindings for a loop"
    #:datum-literals (binding-set)
    (pattern (binding-set ids ... expr:expr)
    #:with step (datum->syntax stx (length (syntax->datum #'(ids ...))))
    #:with (split-expr ...) (process-split #'(expr step))))
  ; todo write some plain racket that splits data in the fashion desired.
  (syntax-parse stx
    [(_ bindings:bind-set exp-seq:expr-seq)
     #''(bindings.split-expr ...)]))

(define-syntax (graph-expression stx)
  (syntax-parse stx
    [(_ foo ...)
     #'7]))

(graphical-program
    (expression-sequence
     (expression
      (loop
       (binding-set
        (identifier-sequence wire)
        (expression (read 3 (delimiter "newline"))))
       (expression-sequence
        (expression (graph-expression (function-call changecolor)))
        (expression
         (loop
          (binding-set
           (identifier-sequence direction magnitude)
           (expression (split-expression wire "comma")))
          (expression-sequence
           (expression
            (assignment
             upmultiplier
             (expression (case-select direction (hashmap U 1 D -1 other 0)))))
           (expression
            (assignment
             leftmultiplier
             (expression (case-select direction (hashmap L 1 R -1 other 0)))))
           (expression
            (graph-expression
             (function-call
              add
              (expression
               (calculation
                (expression upmultiplier)
                (operator "*")
                (expression magnitude)))
              (expression
               (calculation
                (expression rightmultiplier)
                (operator "*")
                (expression magnitude))))))))))))
     (expression
      (graph-expression
       (function-call intersects)
       (function-call magnitudes)
       (function-call minimum)))))
