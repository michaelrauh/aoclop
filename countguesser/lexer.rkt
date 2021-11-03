#lang br
(require brag/support)

(define-lex-abbrev digits (:+ (char-set "0123456789")))
(define-lex-abbrev operators (:+ (char-set "+*-")))

(define aoclop-lexer
  (lexer-srcloc
   ["find" (token 'FIND lexeme)]
   ["assuming" (token 'ASSUMING lexeme)]
   ["by" (token 'BY lexeme)]
   ["dash" (token 'DELIMITER lexeme)]
   ["read" (token 'READ lexeme)]
   ["," (token 'COMMA lexeme)]
   [":" (token 'COLON lexeme)]
   [">=" (token 'GEQ lexeme)]
   ["in" (token 'IN lexeme)]
   [operators (token 'OPERATOR lexeme)]
   ["=" (token 'EQ lexeme)]
   ["end" (token 'END lexeme)]
   ["or" (token 'OR lexeme)]
   ["and" (token 'AND lexeme)]
   [(:seq alphabetic (:* (:or alphabetic numeric "$")))
    (token 'IDENTIFIER (string->symbol lexeme))]
   [digits (token 'INTEGER (string->number lexeme))]
   [whitespace (token lexeme #:skip? #t)]))
(provide aoclop-lexer)
