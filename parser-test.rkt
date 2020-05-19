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

; '(aoclop-program (read 1 (delimiter "nl")) (op "/" 3))
; (read 1 '\n')
; (div-each 3)

; '(aoclop-program (read 1 (delimiter "nl")) (op "/" 3))
; (map (λ (x) (/ x 3)) (read 1 '\n'))

; '(aoclop-program (read 1 (delimiter "nl")) (op "/" 3))
; (for/fold
; ([res (read 1 '\n')])
; ([lambdas '((λ (x) (/ x 3))))])
;  ((lambdas i)))

; '(aoclop-program (read 1 (delimiter "nl")) (op "/" 3))
; (map (compose1 (λ (x) (/ x 3))) (read 1 '\n'))