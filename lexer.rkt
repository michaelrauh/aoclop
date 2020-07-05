#lang br
(require brag/support)

(define-lex-abbrev digits (:+ (char-set "0123456789")))

(define aoclop-lexer
  (lexer-srcloc
   ["read:" (token 'READ lexeme)]
   ["\n" (token 'NEWLINE lexeme)]
   ["nl" (token 'DELIMITER lexeme)]
   ["floor" (token 'OP lexeme)]
   ["identity" (token 'OP lexeme)]
   ["|" (token 'PIPE lexeme)]
   ["^" (token 'UPSCOPE lexeme)]
   ["v" (token 'DOWNSCOPE lexeme)]
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