#lang br/quicklang

(provide #%module-begin)
(require threading)
(require "util.rkt")
(provide read)
(provide delimiter)

(require(for-syntax syntax/parse))

(define (converge proc x)
  (define step (proc x))
  (cond [(<= step 0) 0]
        [else (+ step (converge proc step))]))

(define-syntax-rule (chimera-program read scope-block collect)
  (apply collect (read-scope scope-block read)))
(provide chimera-program)

(define-syntax (read-scope stx)
  (syntax-parse stx
    #:datum-literals (read-scope scope-block converge-block)
    [(read-scope (scope-block (converge-block all-ops:expr)) read:expr) #'(map ((curry converge) all-ops) read)]
    [(read-scope (scope-block all-ops:expr) read:expr) #'(map all-ops read)]))

(define-syntax-rule (all-ops op ...)
  (λ~> op ...))
(provide all-ops)

(define-syntax (op stx)
  (syntax-parse stx
    #:datum-literals (op)
    [(op x "identity") #'(identity x)]
    [(op x "floor") #'(floor x)]
    [(op x "/" divisor:number) #'(/ x divisor)]
    [(op x "-" difference:number) #'(- x difference)]))
(provide op)

(define-syntax-rule (collect "sum") +)
(provide collect)

