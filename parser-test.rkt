#lang br
(require aoclop/parser
         aoclop/tokenizer
         brag/support
         rackunit)

(check-equal?
 (parse-to-datum
  (apply-tokenizer-maker make-tokenizer "\n read: 1 nl \n")) '(aoclop-program (read 1 (delimiter "nl"))))

(check-equal?
 (parse-to-datum
  (apply-tokenizer-maker make-tokenizer "\n read: 1 nl | / 3 \n")) '(aoclop-program (read 1 (delimiter "nl")) (op "/" 3)))