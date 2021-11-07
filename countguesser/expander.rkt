#lang racket

(provide #%top #%app #%datum #%top-interaction #%module-begin)
(require "util.rkt")
(provide read)
(provide delimiter)
(provide operator)

(require(for-syntax syntax/parse racket/list))

(define (int->list n) (if (zero? n) null
                          (append (int->list (quotient n 10)) (list (remainder n 10)))))

(define-syntax (countguesser-program stx)
  (syntax-parse stx
    #:datum-literals (read-block rang-read assume-block)
    [(_ (read-block (range-read number:number delim:string)) (assume-block bool-exp:expr ...))
     #' (let ([data (read number (delimiter delim))])
          (for/sum ([x (in-range (car data) (cadr data))]
                    #:when (and (handle-assumption bool-exp x) ...))
            1))]))
(provide countguesser-program)

(define-syntax (handle-assumption stx)
  (define-syntax-class and-bools
    #:datum-literals (bool-exp loop-expr binding)
    (pattern (bool-exp (loop-exp "and" (binding id:id ...) inner-bool:expr))
             #:with (offset ...) (datum->syntax stx (range (length (syntax->datum #'(id ...)))))))
  (define-syntax-class or-bools
    #:datum-literals (bool-exp loop-expr binding)
    (pattern (bool-exp (loop-exp "or" (binding id:id ...) inner-bool:expr))
             #:with (offset ...) (datum->syntax stx (range (length (syntax->datum #'(id ...)))))))
  (define-syntax-class pador-bools
    #:datum-literals (bool-exp loop-expr binding)
    (pattern (bool-exp (loop-exp "pador" (binding id:id ...) inner-bool:expr))
             #:with (offset ...) (datum->syntax stx (range (length (syntax->datum #'(id ...)))))))
  (syntax-parse stx
    ([_ expr:and-bools x]
     #'(for/and ([expr.id (drop (int->list x) expr.offset)] ...)
         expr.inner-bool))
    ([_ expr:or-bools x]
     #'(for/or ([expr.id (drop (int->list x) expr.offset)] ...)
         expr.inner-bool))
    ([_ expr:pador-bools x]
     #'(for/or ([expr.id (drop (pad (int->list x)) expr.offset)] ...)
         expr.inner-bool))))

(define (pad l)
  (flatten (append (list -1) l (list -1))))

(define-syntax (bool-exp stx)
  (syntax-case stx ()
    [(_ bool "and" bool2) #'(and bool bool2)]
    [(_ arith comp arith2) #'(comp arith arith2)]))
(provide bool-exp)

(define-syntax (comp stx)
  (syntax-case stx ()
    [(_ ">=") #'>=]
    [(_ "<=") #'<=]
    [(_ "=") #'=]
    [(_ "!=") #'!=]))
(provide comp)

(define != (compose1 not =))

(define-syntax (arith-expr stx)
  (syntax-case stx ()
    [(_ id-or-number) #'id-or-number]
    [(_ first "-" second) #'(- first second)]))
(provide arith-expr)