#lang br/quicklang

(provide #%module-begin
         chimera-program
         all-ops
         op
         collect
         read
         delimiter)

(require threading
         "util.rkt"
         (for-syntax syntax/parse))

(define (converge proc x)
  (let ([step (proc x)])
    (if (<= step 0)
        0
        (+ step (converge proc step)))))

(define-syntax-rule (chimera-program read scope-block collect)
  (apply collect (read-scope scope-block read)))

(define-syntax (read-scope stx)
  (syntax-parse stx
    #:datum-literals (read-scope scope-block converge-block)
    [(read-scope (scope-block (converge-block all-ops:expr)) read:expr)
     #'(map ((curry converge) all-ops) read)]
    [(read-scope (scope-block all-ops:expr) read:expr)
     #'(map all-ops read)]))

(define-syntax-rule (all-ops op ...)
  (λ~> op ...))

(define-syntax (op stx)
  (syntax-parse stx
    #:datum-literals (op)
    [(op x "identity") #'(identity x)]
    [(op x "floor") #'(floor x)]
    [(op x "/" divisor:number) #'(/ x divisor)]
    [(op x "-" difference:number) #'(- x difference)]))

(define-syntax-rule (collect "sum") +)

