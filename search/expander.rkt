#lang br/quicklang

(provide #%module-begin)

(define-syntax-rule (search-program find-block satisfying-block return-block)
  return-block)

(define-syntax-rule (return-block expression)
  expression)

(define-syntax-rule (expression lhs operation rhs)
  (operation lhs rhs))

(define-syntax (operator stx)
  (syntax-case stx ()
    [(_ "+") #'+]
    [(_ "*") #'*]))

(search-program
    (find-block
     (assignment-sequence
      (assignment noun (range-expr 0 100))
      (assignment verb (range-expr 0 100))))
    (satisfying-block (function-call tape noun verb) file_2.2_tape.rkt 19690720)
    (return-block
     (expression (expression 5 (operator "*") 100) (operator "+") 3)))