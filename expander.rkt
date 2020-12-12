#lang br/quicklang

(provide #%module-begin)
(require threading)

(define-syntax-rule (aoclop-program read-expr (scope-block (all-ops op ...)) vecop)
  (apply vecop (map (λ~> op ...) read-expr)))
(provide aoclop-program)

(define-syntax (op stx)
  (syntax-case stx ()
    [(op x "identity") #'(identity x)]
    [(op x "floor") #'(floor x)]))
(provide op)

(define-syntax (multop stx)
  (syntax-case stx ()
    [(multop x "/" divisor) #'(/ x divisor)]
    [(multop x "-" difference) #'(- x difference)]))
(provide multop)

(define-syntax (vecop stx)
  (syntax-case stx ()
    [(vecop "sum") #'+]))
(provide vecop)

(define-syntax-rule (delimiter "nl") "\n")
(provide delimiter)

(require 2htdp/batch-io)
(define (read file-number delim)
  (define contents (read-file (string-append (number->string file-number) ".txt")))
  (define strings (string-split contents delim))
  (map string->number strings))
(provide read)