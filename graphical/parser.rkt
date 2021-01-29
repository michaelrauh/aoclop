#lang brag
graphical-program   : expression-sequence
expression-sequence : expression*
expression          : loop | graph-expression | assignment | calculation | IDENTIFIER | read | INTEGER | split-expression | case-select
split-expression    : IDENTIFIER /BY DELIMITER
input               : /INPUT /COLON IDENTIFIER* /END
read                : /READ INTEGER /BY delimiter
delimiter           : DELIMITER
loop                : /FOR identifier-sequence /IN expression /COLON expression-sequence /END
calculation         : expression OPERATOR expression
graph-expression    : /GRAPH /DOT function-call (/DOT function-call)*
assignment          : IDENTIFIER /EQUALS expression
case-select         : /MATCH IDENTIFIER /IN hashmap
hashmap             : /LEFT-BRACKET (IDENTIFIER /COLON INTEGER /COMMA?)* /RIGHT-BRACKET
identifier-sequence : (IDENTIFIER | /COMMA?)+
function-call       : IDENTIFIER /OPEN-PAREN (expression /COMMA?)* /CLOSE-PAREN

