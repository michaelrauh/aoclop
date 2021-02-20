#lang brag
graphical-program   : expression-sequence
expression-sequence : expression*
expression          : loop | graph-expression | assignment | calculation | IDENTIFIER | read-string | INTEGER | split-expression | case-select
split-expression    : IDENTIFIER /BY delimiter
input               : /INPUT /COLON IDENTIFIER* /END
read-string         : /READ INTEGER /BY delimiter
delimiter           : DELIMITER
loop                : /FOR binding-set /COLON expression-sequence /END
binding-set         : identifier-sequence /IN expression
calculation         : expression operator expression
operator            : OPERATOR 
graph-expression    : /GRAPH /DOT function-call (/DOT function-call)*
assignment          : IDENTIFIER /EQUALS expression
case-select         : /MATCH IDENTIFIER /IN hashmap /OR default
default             : INTEGER
hashmap             : /LEFT-BRACKET (STRING /COLON INTEGER /COMMA?)* /RIGHT-BRACKET
identifier-sequence : (IDENTIFIER | /COMMA?)+
function-call       : IDENTIFIER /OPEN-PAREN (expression /COMMA?)* /CLOSE-PAREN

