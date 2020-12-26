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

(check-equal?
 (parse-to-datum
  (apply-tokenizer-maker make-tokenizer "read: 2 comma 1 <- 12 2 <- 2 op <= iterate until op = 99 1 <- 4 end")) '(tape-program
    (read 2 (delimiter "comma"))
    (statement (pointer-assignment 1 12))
    (statement (pointer-assignment 2 2))
    (statement
     (loop
      (identifier-sequence (identifier op))
      (termination-clause op "=" 99)
      (statement (pointer-assignment 1 4))))))