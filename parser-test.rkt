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
; (floor-each)
; (sum-all)

; '(aoclop-program (read 1 (delimiter "nl")) (op "/" 3) (op "floor")
; (sum (map (λ (x) (floor (/ x 3)) (read 1 '\n'))))

; '(aoclop-program (read 1 (delimiter "nl")) (op "/" 3))
; (sum (for/fold
; ([res (read 1 '\n')])
; ([lambdas '((λ (x) (/ x 3)) (λ (x) (floor x)))])
;  ((lambdas i))))

; '(aoclop-program (read 1 (delimiter "nl")) (op "/" 3))
; (sum (map (compose1 (λ (x) (/ x 3)) (λ (x) (floor x))) (read 1 '\n')))