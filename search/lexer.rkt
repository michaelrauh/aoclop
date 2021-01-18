#lang br
(require brag/support)

(define-lex-abbrev digits (:+ (char-set "0123456789")))
(define-lex-abbrev operators (:+ (char-set "+*")))

(define tape-lexer
  (lexer-srcloc
   ["," (token 'COMMA lexeme)]
   ["->" (token 'RIGHT-SKINNY-ARROW lexeme)]
   [":" (token 'COLON lexeme)]
   ["find" (token 'FIND lexeme)]
   ["satisfying" (token 'SATISFYING lexeme)]
   ["foreign" (token 'FOREIGN lexeme)]
   ["return" (token 'RETURN lexeme)]
   ["in" (token 'IN lexeme)]
   [operators (token 'OPERATOR lexeme)]
   ["=" (token 'EQUALS lexeme)]
   ["end" (token 'END lexeme)]
   ["(" (token 'OPEN-PAREN lexeme)]
   [")" (token 'CLOSE-PAREN lexeme)]
   [(:seq alphabetic (:* (:or alphabetic numeric "$" "." "_")))
    (token 'IDENTIFIER (string->symbol lexeme))]
   [digits (token 'INTEGER (string->number lexeme))]
   [whitespace (token lexeme #:skip? #t)]))
(provide tape-lexer)