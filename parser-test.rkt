#lang br
(require aoclop/parser
         aoclop/tokenizer
         brag/support
         rackunit)

(check-equal?
 (parse-to-datum
  (apply-tokenizer-maker make-tokenizer "\nread: 1 nl | v | floor | / 3 | - 2 | ^ | sum \n"))
 '(aoclop-program
    (read 1 (delimiter "nl"))
    (scope-block (all-ops (op "floor") (multop "/" 3) (multop "-" 2)))
    (vecop "sum")))
