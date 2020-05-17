#lang brag
aoclop-program : /NEWLINE read op* /NEWLINE
read           : /READ INTEGER delimiter
delimiter      : DELIMITER
op             : /PIPE OP [INTEGER]