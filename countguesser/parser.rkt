#lang brag
countguesser-program   : read-block assume-block
read-block             : /FIND /COLON range-read /END
range-read             : binding /IN /READ INTEGER /BY DELIMITER
assume-block           : /ASSUMING /COLON bool-exp* /END
bool-exp               : (arith-expr) comp (arith-expr) | loop-expr
loop-expr              : (AND|OR) binding /COLON bool-exp /END
arith-expr             : IDENTIFIER | INTEGER | (arith-expr OPERATOR arith-expr)
binding                : IDENTIFIER /COMMA IDENTIFIER
comp                   : EQ | GEQ