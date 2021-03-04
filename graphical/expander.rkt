#lang br/quicklang

(provide #%module-begin)

(require "../util.rkt")
(require "graph.rkt")
(require threading)
(provide read-string)
(provide delimiter)
(provide operator)


(define graph (new graph%))

(require(for-syntax syntax/parse racket/list))

(define-syntax-rule (graphical-program expression-sequence)
  expression-sequence)
(provide graphical-program)

(define-syntax-rule (expression-sequence expr ...)
  (begin expr ...))
(provide expression-sequence)

(define-syntax-rule (expression subexpr)
  subexpr)
(provide expression)

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
(provide loop)

(define (split-expression contents delim)
  (string-split contents delim))
(provide split-expression)

(define-syntax-rule (assignment from to)
  (define from to))
(provide assignment)

(define-syntax-rule (case-select to-find (hashmap entry ...) (default default-value))
  (hash-ref (hash entry ...) to-find default-value))
(provide case-select)

(define-syntax (graph-expression stx)
  (syntax-parse stx
    #:datum-literals (graph-expression function-call)
    [(graph-expression (function-call subcall arg ...))
     #'(send graph subcall arg ...)]
    [(graph-expression (function-call subcall arg ...) func-call ...)
     #'(helper-func (send graph subcall arg ...) func-call ...)]))
(provide graph-expression)

(define-syntax (helper-func stx)
  (syntax-parse stx
    #:datum-literals (function-call)
    [(_ graph final)
     #'(send graph final)]
    [(_ graph (function-call first-subcall) (function-call subcall) ...)
     #'(helper-func (send graph first-subcall) subcall ...)]))

(define-syntax-rule (calculation expr1 op expr2)
  (op (if (string? expr1) (string->number expr1) expr1) (if (string? expr2) (string->number expr2) expr2)))
(provide calculation)