#lang tape
read: 2 comma
1 <- 12
2 <- 2

firstdigit <= takeright
if firstdigit = 9:
  exit 

operation <= match firstdigit in {1: +, 2: *}
advance -> p1
advance -> p2
result <= evaluate p1 operation p2 
advance <- result