#lang br/quicklang

(provide #%module-begin)

(require "../util.rkt")
(require "../temp.rkt")
(require threading)
(provide read-string)
(provide delimiter)


(define graph (new graph%))

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
     #'(for ([iter gen-expr.expr])
         (let ([id-seq.ident (substring iter id-seq.offset (+ 1 id-seq.offset))] ... [id-seq.ident-l (substring iter id-seq.step)])
         subexpr ...))]))

(define (split-expression contents delim)
  (string-split contents delim))

(define-syntax-rule (assignment from to)
  (define from to))

(define-syntax-rule (case-select to-find (hashmap entry ...) (default default-value))
  (hash-ref (hash entry ...) to-find default-value))

(define-syntax (graph-expression stx)
  (syntax-parse stx
    #:datum-literals (graph-expression function-call)
    [(graph-expression (function-call subcall))
     #'(send graph subcall)]))

(graphical-program
    (expression-sequence
     (expression
      (loop
       (binding-set
        (identifier-sequence wire)
        (expression (read-string 3 (delimiter "newline"))))
       (expression-sequence
        (expression (graph-expression (function-call changecolor)))
        (expression
         (loop
          (binding-set
           (identifier-sequence direction magnitude)
           (expression (split-expression wire (delimiter "comma"))))
          (expression-sequence
           (expression
            (assignment
             upmultiplier
             (expression
              (case-select direction (hashmap "U" 1 "D" -1) (default 0)))))
           (expression
            (assignment
             leftmultiplier
             (expression
              (case-select direction (hashmap "L" 1 "R" -1) (default 0)))))
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