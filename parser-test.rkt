#lang br
(require aoclop/parser
         aoclop/tokenizer
         brag/support
         rackunit)

(check-equal?
 (parse-to-datum
  (apply-tokenizer-maker make-tokenizer "\n read: 1 nl | v | floor | floor | floor | ^ \n")) '(aoclop-program (read 1 (delimiter "nl")) (scope-block (all-ops (op "floor") (op "floor") (op "floor")))))


;read 1: \n | / 3 | floor | - 2 | ^ | sum
