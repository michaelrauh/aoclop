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
    #:datum-literals (read-block range-read assume-block)
    [(_ (read-block (range-read number:number delim:string)) (assume-block bool-exp:expr ...))
     #' (let ([data (read number (delimiter delim))])
          (for/sum ([x (in-range (car data) (cadr data))]
                    #:when (and (handle-assumption bool-exp x) ...))
            1))]))
(provide countguesser-program)

(define-syntax (handle-assumption stx)
  (define-syntax-class binding
    #:datum-literals (binding)
    (pattern (binding id:id ...)
             #:with (offset ...) (datum->syntax stx (range (length (syntax->datum #'(id ...)))))))  
  (syntax-parse stx
    #:datum-literals (bool-exp loop-expr)
    ([_ (bool-exp (loop-expr "and" bind:binding inner-bool:expr)) x]
     #'(for/and ([bind.id (drop (int->list x) bind.offset)] ...)
         inner-bool))
    ([_ (bool-exp (loop-expr "or" bind:binding inner-bool:expr)) x]
     #'(for/or ([bind.id (drop (int->list x) bind.offset)] ...)
         inner-bool))
    ([_ (bool-exp (loop-expr "pador" bind:binding inner-bool:expr)) x]
     #'(for/or ([bind.id (drop (pad (int->list x)) bind.offset)] ...)
         inner-bool))))

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