#lang br/quicklang

(provide #%module-begin)
(require threading)
(require "../util.rkt")
(provide read)
(provide delimiter)

(define (converge proc x)
  (define step (proc x))
  (cond [(<= step 0) 0]
        [else (+ step (converge proc step))]))

(define-syntax-rule (mappetizer-program read scope-block collect)
  (apply collect (read-scope scope-block read)))
(provide mappetizer-program)

(define-syntax (read-scope stx)
  (syntax-case stx ()
    [(read-scope (scope-block (converge-block all-ops)) read) #'(map ((curry converge) all-ops) read)]
    [(read-scope (scope-block all-ops) read) #'(map all-ops read)]))

(define-syntax-rule (all-ops op ...)
  (λ~> op ...))
(provide all-ops)

(define-syntax (op stx)
  (syntax-case stx ()
    [(op x "identity") #'(identity x)]
    [(op x "floor") #'(floor x)]
    [(op x "/" divisor) #'(/ x divisor)]
    [(op x "-" difference) #'(- x difference)]))
(provide op)

(define-syntax-rule (collect "sum") +)
(provide collect)

