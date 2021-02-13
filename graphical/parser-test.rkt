#lang br
(require graphical/parser
         graphical/tokenizer
         brag/support
         rackunit)

(check-equal?
 (parse-to-datum
  (apply-tokenizer-maker make-tokenizer "
for wire in read: 3 by newline:
  graph.changecolor()
  for direction, magnitude in wire by comma:
    upmultiplier = match direction in {U: 1, D: -1, other: 0}
    leftmultiplier = match direction in {L: 1, R: -1, other: 0}
    graph.add(upmultiplier * magnitude, rightmultiplier * magnitude)
  end
end

graph.intersects().magnitudes().minimum()")) '(graphical-program
    (expression-sequence
     (expression
      (loop
       (binding-set
        (identifier-sequence wire)
        (expression (read 3 (delimiter "newline"))))
       (expression-sequence
        (expression (graph-expression (function-call changecolor)))
        (expression
         (loop
          (binding-set
           (identifier-sequence direction magnitude)
           (expression (split-expression wire "comma")))
          (expression-sequence
           (expression
            (assignment
             upmultiplier
             (expression (case-select direction (hashmap U 1 D -1 other 0)))))
           (expression
            (assignment
             leftmultiplier
             (expression (case-select direction (hashmap L 1 R -1 other 0)))))
           (expression
            (graph-expression
             (function-call
              add
              (expression
               (calculation
                (expression upmultiplier)
                (operator "*")
                (expression magnitude)))
              (expression
               (calculation
                (expression rightmultiplier)
                (operator "*")
                (expression magnitude))))))))))))
     (expression
      (graph-expression
       (function-call intersects)
       (function-call magnitudes)
       (function-call minimum))))))
