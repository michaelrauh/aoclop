#lang br
(require search/parser
         search/tokenizer
         brag/support
         rackunit)

(check-equal?
 (parse-to-datum
  (apply-tokenizer-maker make-tokenizer "find: noun in 0->100 verb in 0->100 end satisfying: foreign tape(noun, verb) in file_2.2_tape.rkt = 19690720 end return: noun * 100 + verb end")) '
(search-program
    (find-block
     (assignment-sequence
      (assignment noun (range-expr 0 100))
      (assignment verb (range-expr 0 100))))
    (satisfying-block (function-call tape noun verb) file_2.2_tape.rkt 19690720)
    (return-block (expression (expression noun "*" 100) "+" verb))))