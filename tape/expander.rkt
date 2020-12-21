#lang br/quicklang

(provide #%module-begin)
(require threading)
(require "../util.rkt")
(provide read)
(provide delimiter)

(define-syntax-rule (tape-program read)
  read)
(provide tape-program)