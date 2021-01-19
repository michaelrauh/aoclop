#lang br/quicklang

(require (for-syntax racket/string))

(define-syntax (import-file stx)
  (syntax-case stx ()
    [(_ str) (with-syntax (
                    [filename (datum->syntax stx (string-replace (symbol->string (syntax->datum #'str)) "file_" ""))])
       #'(require filename))]))

(import-file file_2.2_tape.rkt)

tape