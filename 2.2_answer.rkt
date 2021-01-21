#lang search

find:
 noun in 0->100
 verb in 0->100
end
satisfying:
  foreign tape(noun, verb) in file_2.2_tape.rkt = 19690720
end
return:
  noun * 100 + verb
end