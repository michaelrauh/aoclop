#lang br/quicklang

(provide #%module-begin)

(define-syntax-rule (aoclop-program read-expr (scope-block (all-ops operation ...)))
  (map (λ (x) (x-then-ops-in-order (x (operation ...)))) read-expr))
(provide aoclop-program)


(define-syntax (x-then-ops-in-order stx)
  (syntax-case stx ()
    [(_ (lambda-x (ops ...))) (syntax-case #'(ops ...) ()
                                [((_ "identity")) #'(identity lambda-x)]
                                [((_ "identity") otherop ...) #'(identity (x-then-ops-in-order(lambda-x (otherop ...))))]
                                [((_ "floor")) #'(floor lambda-x)]
                                [((_ "floor") otherop ...) #'(floor (x-then-ops-in-order(lambda-x (otherop ...))))])]))


(define-syntax-rule (delimiter "nl") "\n")
(provide delimiter)

(require 2htdp/batch-io)
(define (read file-number delim)
  (define contents (read-file (string-append (number->string file-number) ".txt")))
  (define strings (string-split contents delim))
  (map string->number strings))
(provide read)