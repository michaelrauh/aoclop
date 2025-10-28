#lang chimera 

tape main
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
end

main