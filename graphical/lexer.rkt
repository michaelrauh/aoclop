#lang br
(require brag/support)

(define-lex-abbrev digits (:+ (char-set "-0123456789")))
(define-lex-abbrev operators (:+ (char-set "+*")))

(define aoclop-lexer
  (lexer-srcloc
   ["read:" (token 'READ lexeme)]
   ["graph" (token 'GRAPH lexeme)]
   ["comma" (token 'DELIMITER lexeme)]
   ["newline" (token 'DELIMITER lexeme)]
   ["for" (token 'FOR lexeme)]
   ["by" (token 'BY lexeme)]
   ["input" (token 'INPUT lexeme)]
   ["<-" (token 'LEFT-SKINNY-ARROW lexeme)]
   ["{" (token 'LEFT-BRACKET lexeme)]
   ["}" (token 'RIGHT-BRACKET lexeme)]
   ["(" (token 'OPEN-PAREN lexeme)]
   [")" (token 'CLOSE-PAREN lexeme)]
   [":" (token 'COLON lexeme)]
   ["," (token 'COMMA lexeme)]
   ["." (token 'DOT lexeme)]
   ["in" (token 'IN lexeme)]
   ["match" (token 'MATCH lexeme)]
   ["evaluate" (token 'EVALUATE lexeme)]
   [operators (token 'OPERATOR lexeme)]
   ["->" (token 'RIGHT-SKINNY-ARROW lexeme)]
   ["<=" (token 'LEFT-FAT-ARROW lexeme)]
   ["=" (token 'EQUALS lexeme)]
   ["iterate" (token 'ITERATE lexeme)]
   ["end" (token 'END lexeme)]
   ["until" (token 'UNTIL lexeme)]
   [(:seq alphabetic (:* (:or alphabetic numeric "$")))
    (token 'IDENTIFIER (string->symbol lexeme))]
   [digits (token 'INTEGER (string->number lexeme))]
   [whitespace (token lexeme #:skip? #t)]))
(provide aoclop-lexer)