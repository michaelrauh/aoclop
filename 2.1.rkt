#lang tape
read: 2 comma
1 <- 12
2 <- 2
op foo bar baz <= iterate until op = 99
  2 -> temp
  4 -> temptwo
  foo <- temp
end
