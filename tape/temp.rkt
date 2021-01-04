#lang racket
(require (for-syntax racket/list))

(define-syntax (statement stx)
  (syntax-case stx ()
    [(_ operation)
     (with-syntax ([(op ...) (datum->syntax stx (range 3))])
       #''((+ 1 op) ...))]))
(statement (+ 1 op))

