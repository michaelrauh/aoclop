#lang chimera 

tape helper
  input:
    noun verb
  end

  read: 2 comma
  1 <- noun
  2 <- verb
  op pointerOne pointerTwo destination <= iterate until op = 99
    operation <= match op in {1: +, 2: *}
    pointerOne -> p1
    pointerTwo -> p2
    result <= evaluate p1 operation p2 
    destination <- result
  end
end

search main
  find:
    noun in 0->100
    verb in 0->100
  end
  satisfying:
    foreign helper(noun, verb) = 19690720
  end
  return:
    noun * 100 + verb
  end
end

main