#lang br
(require aoclop/parser
         aoclop/tokenizer
         brag/support
         rackunit)

(check-equal?
 (parse-to-datum
  (apply-tokenizer-maker make-tokenizer "\n read: 1 nl | v | floor | floor | ^ \n")) '(aoclop-program (read 1 (delimiter "nl")) (scope-block (op "floor" (op "floor")))))