#lang br
(require brag/support)

(define-lex-abbrev digits (:+ (char-set "0123456789")))

(define tape-lexer
  (lexer-srcloc
   ["read:" (token 'READ lexeme)]
   ["comma" (token 'DELIMITER lexeme)]
   ["<-" (token 'LEFT-SKINNY-ARROW lexeme)]
   ["->" (token 'RIGHT-SKINNY-ARROW lexeme)]
   ["<=" (token 'LEFT-FAT-ARROW lexeme)]
   ["=" (token 'BOOLEAN-DYAD lexeme)]
   ["iterate" (token 'ITERATE lexeme)]
   ["end" (token 'END lexeme)]
   ["until" (token 'UNTIL lexeme)]
   [(:seq alphabetic (:* (:or alphabetic numeric "$")))
    (token 'IDENTIFIER (string->symbol lexeme))]
   [digits (token 'INTEGER (string->number lexeme))]
   [whitespace (token lexeme #:skip? #t)]))
(provide tape-lexer)