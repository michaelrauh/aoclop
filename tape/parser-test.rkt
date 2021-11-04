#lang br
(require tape/parser
         tape/tokenizer
         brag/support
         rackunit)

(check-equal?
 (parse-to-datum
  (apply-tokenizer-maker make-tokenizer "
read: 2 comma
1 <- 12
2 <- 2
op pointerOne pointerTwo destination <= iterate until op = 99
    operation <= match op in {1: +, 2: *}
    pointerOne -> p1
    pointerTwo -> p2
    result <= evaluate p1 operation p2 
    destination <- result
end
"))
 '(tape-program
    (read 2 (delimiter "comma"))
    (statement-sequence
     (statement (pointer-assignment 1 12))
     (statement (pointer-assignment 2 2))
     (statement
      (loop
       (identifier-sequence op pointerOne pointerTwo destination)
       (termination-clause op "=" 99)
       (read-sequence
        (assignment
         operation
         (case-select op (hashmap 1 (operator "+") 2 (operator "*"))))
        (tape-read pointerOne p1)
        (tape-read pointerTwo p2)
        (assignment result (evaluation p1 operation p2)))
       (statement (pointer-assignment destination result)))))))

(check-equal?
 (parse-to-datum
  (apply-tokenizer-maker make-tokenizer "input: identone identtwo end read: 2 comma 1 <- 12 2 <- 2 op foo bar baz <= iterate until op = 99 2 -> temp 4 -> temptwo operation <= match op in {1: +, 2: *} result <= evaluate p1 operation p2 foo <- temp end"))
 '(tape-program
    (input identone identtwo)
    (read 2 (delimiter "comma"))
    (statement-sequence
     (statement (pointer-assignment 1 12))
     (statement (pointer-assignment 2 2))
     (statement
      (loop
       (identifier-sequence op foo bar baz)
       (termination-clause op "=" 99)
       (read-sequence
        (tape-read 2 temp)
        (tape-read 4 temptwo)
        (assignment
         operation
         (case-select op (hashmap 1 (operator "+") 2 (operator "*"))))
        (assignment result (evaluation p1 operation p2)))
       (statement (pointer-assignment foo temp)))))))