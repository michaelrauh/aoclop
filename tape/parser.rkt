#lang brag
tape-program       : /NEWLINE read /NEWLINE
read               : /READ INTEGER delimiter
delimiter          : DELIMITER
statement          : pointer-assignment
pointer-assignment : INTEGER /LEFT-SKINNY-ARROW INTEGER