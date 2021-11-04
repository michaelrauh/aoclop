#lang racket

(provide #%top #%app #%datum #%top-interaction #%module-begin)
(require "util.rkt")
(provide read)
(provide delimiter)
(provide operator)

(require(for-syntax syntax/parse racket/list))

(define (int->list n) (if (zero? n) `()
                          (append (int->list (quotient n 10)) (list (remainder n 10)))))

(define-syntax (countguesser-program stx)
  (define-syntax-class assume
    #:description "anded together rules"
    #:datum-literals (assume-block)
    (pattern (assume-block bool-exp ...)))
  (define-syntax-class read-class
    #:description "the read range"
    #:datum-literals (read-block range-read)
    (pattern (read-block (range-read number delim))))
  (syntax-parse stx
    [(_ read-block:read-class assum:assume)
     #'(for/sum ([x (in-range (car (read read-block.number (delimiter read-block.delim))) (cadr (read read-block.number (delimiter read-block.delim))))]
                 #:when (and (handle-assumption assum.bool-exp x) ...))
         1)]))
(provide countguesser-program)

(define-syntax (handle-assumption stx)
  (define-syntax-class and-bools
    #:description "an and expression reducing to true or false"
    #:datum-literals (bool-exp loop-expr binding)
    (pattern (bool-exp (loop-exp "and" (binding id ...) inner-bool))
             #:with step (datum->syntax stx (length (syntax->datum #'(id ...))))
             #:with (offset ...) (datum->syntax stx (range (syntax->datum #'step)))))
  (define-syntax-class or-bools
    #:description "an or expression reducing to true or false"
    #:datum-literals (bool-exp loop-expr binding)
    (pattern (bool-exp (loop-exp "or" (binding id ...) inner-bool))
             #:with step (datum->syntax stx (length (syntax->datum #'(id ...))))
             #:with (offset ...) (datum->syntax stx (range (syntax->datum #'step)))))
  (syntax-parse stx
    ([_ expr:and-bools x]
     #'(for/and ([expr.id (drop (int->list x) expr.offset)] ...)
         expr.inner-bool))
    ([_ expr:or-bools x]
     #'(for/or ([expr.id (drop (int->list x) expr.offset)] ...)
         expr.inner-bool))))

(define-syntax-rule (bool-exp arith comp arith2)
  (comp arith arith2))
(provide bool-exp)

(define-syntax (comp stx)
  (syntax-case stx ()
    [(_ ">=") #'>=]
    [(_ "<=") #'<=]
    [(_ "=") #'=]))
(provide comp)

(define-syntax (arith-expr stx)
  (syntax-case stx ()
    [(_ id-or-number) #'id-or-number]
    [(_ first "-" second) #'(- first second)]))
(provide arith-expr)