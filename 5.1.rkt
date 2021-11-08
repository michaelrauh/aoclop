#lang tape

read: 5 comma
firstdigit <= takeright 

if firstdigit = 9:
  exit 

takeright

if firstdigit = 3:
 advance  <- read

if firstdigit = 4:
  read  <= match takeright in {0: ->, 1: <=}
  param <= read advance
  evaluate write param

op <= match firstdigit in {1: +, 2: *}
read1 <= match takeright in {0: ->, 1: <=}
read2 <= match takeright in {0: ->, 1: <=}

param1 = read1 advance
param2 = read2 advance

advance <- evaluate param1 op param2
