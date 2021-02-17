#lang br/quicklang

(provide #%module-begin)
(require threading)
(require "../util.rkt")
(provide (rename-out [read-string read]))
(provide delimiter)

(require(for-syntax syntax/parse racket/list))

(define-syntax-rule (graphical-program (expression-sequence expr ...))
  (expr ...))

(define-syntax-rule (expression subexpr)
  subexpr)

(define-for-syntax (process-split stx)
  stx)

(define-syntax (loop stx)
  (define-syntax-class many-idents
    #:datum-literals (identifier-sequence)
    (pattern (_ ident ... ident-l)
             #:with step (datum->syntax stx (length (syntax->datum #'(ident ...))))
             #:with (offset ...) (datum->syntax stx (range (syntax->datum #'step)))))
  (define-syntax-class gen-data
    #:datum-literals (expression)
    (pattern (expression expr)))
  
  (syntax-parse stx
    #:datum-literals (binding-set expression-sequence)
    [(_ (binding-set id-seq:many-idents gen-expr:gen-data) (expression subexpr ...))
     #'(for ([id-seq.ident (list (substring gen-expr.expr id-seq.offset (+ 1 id-seq.offset)))] ... [id-seq.ident-l (list (substring gen-expr.expr id-seq.step))])
         subexpr ...)]))

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