#lang br
(require brag/support)

(define-lex-abbrev digits (:+ (char-set "0123456789")))

(define aoclop-lexer
  (lexer-srcloc
   ["read:" (token 'READ lexeme)]
   ["\n" (token 'NEWLINE lexeme)]
   [digits (token 'INTEGER (string->number lexeme))]
   [whitespace (token lexeme #:skip? #t)]))
(provide aoclop-lexer)


(module+ test
  (require rackunit)
  (define (lex str)
    (apply-port-proc aoclop-lexer str))
  
  (check-equal? (lex "read: 1 \n |") (list
   (srcloc-token
    (token-struct 'READ "read:" #f #f #f #f #f)
    (srcloc 'string 1 0 1 5))
   (srcloc-token (token-struct '| | #f #f #f #f #f #t) (srcloc 'string 1 5 6 1))
   (srcloc-token
    (token-struct 'INTEGER 1 #f #f #f #f #f)
    (srcloc 'string 1 6 7 1))
   (srcloc-token (token-struct '| | #f #f #f #f #f #t) (srcloc 'string 1 7 8 1))
   (srcloc-token
    (token-struct 'NEWLINE "\n" #f #f #f #f #f)
    (srcloc 'string 1 8 9 1))
   (srcloc-token (token-struct '| | #f #f #f #f #f #t) (srcloc 'string 2 0 10 1))
   (srcloc-token
    (token-struct 'PIPE "|" #f #f #f #f #f)
    (srcloc 'string 2 1 11 1)))))