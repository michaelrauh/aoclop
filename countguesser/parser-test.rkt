#lang br
(require countguesser/parser
         countguesser/tokenizer
         brag/support
         rackunit)

(check-equal?
 (parse-to-datum
  (apply-tokenizer-maker make-tokenizer "

find:
  read 4 by dash
end

assuming:
  and a, b:
    a - b <= 0
  end

  or a, b:
    a = b
  end
end
  
  ")) '(countguesser-program
    (read-block (range-read 4 "dash"))
    (assume-block
     (bool-exp
      (loop-expr
       "and"
       (binding a b)
       (bool-exp
        (arith-expr (arith-expr a) "-" (arith-expr b))
        (comp "<=")
        (arith-expr 0))))
     (bool-exp
      (loop-expr
       "or"
       (binding a b)
       (bool-exp (arith-expr a) (comp "=") (arith-expr b)))))))

(check-equal?
 (parse-to-datum
  (apply-tokenizer-maker make-tokenizer "

find:
  read 4 by dash
end

assuming:
  and a, b:
    a - b <= 0
  end

  pador a, b, c, d:
    b = c and a != b and c != d
  end
end
  
  ")) '(countguesser-program
    (read-block (range-read 4 "dash"))
    (assume-block
     (bool-exp
      (loop-expr
       "and"
       (binding a b)
       (bool-exp
        (arith-expr (arith-expr a) "-" (arith-expr b))
        (comp "<=")
        (arith-expr 0))))
     (bool-exp
      (loop-expr
       "pador"
       (binding a b c d)
       (bool-exp
        (bool-exp
         (bool-exp (arith-expr b) (comp "=") (arith-expr c))
         "and"
         (bool-exp (arith-expr a) (comp "!=") (arith-expr b)))
        "and"
        (bool-exp (arith-expr c) (comp "!=") (arith-expr d))))))))
