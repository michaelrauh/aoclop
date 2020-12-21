#lang brag
tape-program       : /NEWLINE* read /NEWLINE* (statement /NEWLINE)* /NEWLINE*
read               : /READ INTEGER delimiter
delimiter          : DELIMITER
statement          : pointer-assignment
pointer-assignment : INTEGER /LEFT-SKINNY-ARROW INTEGER