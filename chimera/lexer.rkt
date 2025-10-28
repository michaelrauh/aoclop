#lang br
(require brag/support)

(define-lex-abbrev digits (:+ (char-set "0123456789")))

(define aoclop-lexer
  (lexer-srcloc
   ["read:" (token 'READ lexeme)]
   ["read" (token 'READ lexeme)]
   ["comma" (token 'DELIMITER lexeme)]
   ["input" (token 'INPUT lexeme)]
   ["match" (token 'MATCH lexeme)]
   ["<-" (token 'LEFT-SKINNY-ARROW lexeme)]
   ["{" (token 'LEFT-BRACKET lexeme)]
   ["}" (token 'RIGHT-BRACKET lexeme)]
   [":" (token 'COLON lexeme)]
   ["," (token 'COMMA lexeme)]
   ["." (token 'DOT lexeme)]
   ["end" (token 'END lexeme)]
   ["in" (token 'IN lexeme)]
   ["evaluate" (token 'EVALUATE lexeme)]
   ["for" (token 'FOR lexeme)]
   ["by" (token 'BY lexeme)]
   ["graph" (token 'GRAPH lexeme)]
   ["or" (token 'OR lexeme)]
   ["and" (token 'AND lexeme)]
   ["pador" (token 'PADOR lexeme)]
   ["->" (token 'RIGHT-SKINNY-ARROW lexeme)]
   ["<=" (token 'LEFT-FAT-ARROW lexeme)]
   ["=" (token 'BOOLEAN-DYAD lexeme)]
   [">=" (token 'GEQ lexeme)]
   ["!=" (token 'NEQ lexeme)]
   ["iterate" (token 'ITERATE lexeme)]
   ["end" (token 'END lexeme)]
   ["until" (token 'UNTIL lexeme)]
   ["mappetizer" (token 'MAPPETIZER lexeme)]
   ["tape" (token 'TAPE lexeme)]
   ["search" (token 'SEARCH lexeme)]
   ["graphical" (token 'GRAPHICAL lexeme)]
   ["countguesser" (token 'COUNTGUESSER lexeme)]
   ["find" (token 'FIND lexeme)]
   ["satisfying" (token 'SATISFYING lexeme)]
   ["assuming" (token 'ASSUMING lexeme)]
   ["foreign" (token 'FOREIGN lexeme)]
   ["return" (token 'RETURN lexeme)]
   ["nl" (token 'DELIMITER lexeme)]
   ["newline" (token 'DELIMITER lexeme)]
   ["dash" (token 'DELIMITER lexeme)]
   ["floor" (token 'OP lexeme)]
   ["identity" (token 'OP lexeme)]
   ["|" (token 'PIPE lexeme)]
   ["/" (token 'OP lexeme)]
   ["+" (token 'OP lexeme)]
   ["*" (token 'OP lexeme)]
   ["-" (token 'OP lexeme)]
   [">" (token 'GT lexeme)]
   ["<" (token 'LT lexeme)]
   ["sum" (token 'COLLECT lexeme)]
   ["^" (token 'UPSCOPE lexeme)]
   ["v" (token 'DOWNSCOPE lexeme)]
   ["(" (token 'OPEN-PAREN lexeme)]
   [")" (token 'CLOSE-PAREN lexeme)]
   [(:or (from/to "\"" "\"") (from/to "'" "'"))
    (token 'STRING
           (substring lexeme
                      1 (sub1 (string-length lexeme))))]
   [(:seq alphabetic (:* (:or alphabetic numeric "$" "_"))) (token 'IDENTIFIER (string->symbol lexeme))]
   [digits (token 'INTEGER (string->number lexeme))]
   [whitespace (token lexeme #:skip? #t)]))
(provide aoclop-lexer)


(module+ test
  (require rackunit)
  (define (lex str)
    (apply-port-proc aoclop-lexer str))
  
   (list
   (srcloc-token
    (token-struct 'NEWLINE "\n" #f #f #f #f #f)
    (srcloc 'string 1 0 1 1))
   (srcloc-token
    (token-struct 'READ "read:" #f #f #f #f #f)
    (srcloc 'string 2 0 2 5))
   (srcloc-token (token-struct '| | #f #f #f #f #f #t) (srcloc 'string 2 5 7 1))
   (srcloc-token
    (token-struct 'INTEGER 1 #f #f #f #f #f)
    (srcloc 'string 2 6 8 1))
   (srcloc-token (token-struct '| | #f #f #f #f #f #t) (srcloc 'string 2 7 9 1))
   (srcloc-token
    (token-struct 'DELIMITER "nl" #f #f #f #f #f)
    (srcloc 'string 2 8 10 2))))