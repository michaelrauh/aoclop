#lang tape
read: 2 comma
1 <- 12
2 <- 2
op foo bar baz <= iterate until op = 99
  operation <= match op in {1: +, 2: *}
  2 -> temp
  4 -> temptwo
  thing <= 7
  otherthing <= temptwo
  foo <- otherthing
end
