#lang br
(require tape/parser
         tape/tokenizer
         brag/support
         rackunit)

(check-equal?
 (parse-to-datum
  (apply-tokenizer-maker make-tokenizer "\n read: 2 comma \n 5 <- 7 \n")) '(tape-program
    (read 2 (delimiter "comma"))
    (statement (pointer-assignment 5 7))))