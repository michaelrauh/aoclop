#lang br
(require tape/parser
         tape/tokenizer
         brag/support
         rackunit)

(check-equal?
 (parse-to-datum
  (apply-tokenizer-maker make-tokenizer "\n read: 2 comma \n")) '(tape-program (read 2 (delimiter "comma"))))