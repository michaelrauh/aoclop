#lang br
(require aoclop/parser
         aoclop/tokenizer
         brag/support
         rackunit)

(check-equal?
 (parse-to-datum
  (apply-tokenizer-maker make-tokenizer "\n read: 1 nl | v | / 3 | floor | - 2 | ^ | sum \n")) '(aoclop-program
    (read 1 (delimiter "nl"))
    (scope-block (all-ops (op "/" 3) (op "floor") (op "-" 2)))
    (collect "sum")))
