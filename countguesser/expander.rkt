#lang racket

(provide #%top #%app #%datum #%top-interaction #%module-begin)
(require "util.rkt")
(provide read-string)
(provide delimiter)
(provide operator)

(require(for-syntax syntax/parse racket/list))

(define-syntax-rule (countguesser-program read assume) '(read assume))
(provide countguesser-program)

