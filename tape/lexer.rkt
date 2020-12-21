#lang br
(require brag/support)

(define-lex-abbrev digits (:+ (char-set "0123456789")))

(define tape-lexer
  (lexer-srcloc
   ["read:" (token 'READ lexeme)]
   ["\n" (token 'NEWLINE lexeme)]
   ["comma" (token 'DELIMITER lexeme)]
   [digits (token 'INTEGER (string->number lexeme))]
   [whitespace (token lexeme #:skip? #t)]))
(provide tape-lexer)