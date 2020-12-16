#lang br/quicklang

(provide #%module-begin)
(require threading)

(define (converge proc x)
  (define step (proc x))
  (cond [(<= step 0) 0]
        [else (+ step (converge proc step))]))

(define-syntax (aoclop-program stx)
  (syntax-case stx ()
    [(aoclop-program read-expr (scope-block (converge-block (all-ops op ...))) collect) #'(apply collect (map ((curry converge) (λ~> op ...)) read-expr))]
    [(aoclop-program read-expr (scope-block (all-ops op ...)) collect) #'(apply collect (map (λ~> op ...) read-expr))]))
(provide aoclop-program)

(define-syntax (op stx)
  (syntax-case stx ()
    [(op x "identity") #'(identity x)]
    [(op x "floor") #'(floor x)]
    [(op x "/" divisor) #'(/ x divisor)]
    [(op x "-" difference) #'(- x difference)]))
(provide op)

(define-syntax-rule (collect "sum") +)
(provide collect)

(define-syntax-rule (delimiter "nl") "\n")
(provide delimiter)

(require 2htdp/batch-io)
(define (read file-number delim)
  (define contents (read-file (string-append (number->string file-number) ".txt")))
  (define strings (string-split contents delim))
  (map string->number strings))
(provide read)
  