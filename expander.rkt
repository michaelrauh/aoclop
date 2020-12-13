#lang br/quicklang

(provide #%module-begin)
(require threading)

(define-syntax-rule (aoclop-program read-expr (scope-block (all-ops op ...)))
  (map (λ~> op ...) read-expr))
(provide aoclop-program)

(define-syntax (op stx)
  (syntax-case stx ()
    [(op x "identity") #'(identity x)]
    [(op x "floor") #'(floor x)]
    [(op x "/" divisor) #'(/ x divisor)]))
(provide op)

(define-syntax-rule (delimiter "nl") "\n")
(provide delimiter)

(require 2htdp/batch-io)
(define (read file-number delim)
  (define contents (read-file (string-append (number->string file-number) ".txt")))
  (define strings (string-split contents delim))
  (map string->number strings))
(provide read)

;(aoclop-program (read 1 (delimiter "nl")) (scope-block (all-ops (op "identity") (op "floor"))))
;(map (λ~> (op "identity") (op "floor")) ((read 1 (delimiter "nl"))))
;(map (λ~> (/ 3) floor (- 2)) '(1 2 3))