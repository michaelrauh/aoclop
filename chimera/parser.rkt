#lang brag
chimera-program     : (tape-program | mappetizer-block | search-program | graphical-program | countguesser-program)+ IDENTIFIER

mappetizer-block    : /MAPPETIZER IDENTIFIER read scope-block /PIPE collect /END
read                : /READ INTEGER delimiter
scope-block         : /PIPE /DOWNSCOPE /PIPE all-ops /PIPE /UPSCOPE | /PIPE /DOWNSCOPE /PIPE converge-block /PIPE /UPSCOPE
delimiter           : DELIMITER
all-ops             : op*
converge-block      : /GT all-ops /LT
op                  : OP | OP INTEGER | OP /PIPE | OP INTEGER /PIPE
collect             : COLLECT

search-program      : /SEARCH IDENTIFIER find-block satisfying-block return-block /END
find-block          : /FIND /COLON search-assignment-sequence /END
search-assignment-sequence : search-assignment*
search-assignment   : IDENTIFIER /IN range-expr
range-expr          : INTEGER /RIGHT-SKINNY-ARROW INTEGER
satisfying-block    : /SATISFYING /COLON /FOREIGN function-call /BOOLEAN-DYAD INTEGER /END
function-call       : IDENTIFIER /OPEN-PAREN IDENTIFIER /COMMA IDENTIFIER /CLOSE-PAREN
return-block        : /RETURN /COLON expression /END

tape-program        : /TAPE IDENTIFIER input? read statement-sequence /END
input               : /INPUT /COLON IDENTIFIER* /END
statement-sequence  : statement*
pointer-assignment  : (INTEGER | IDENTIFIER) /LEFT-SKINNY-ARROW (INTEGER | IDENTIFIER)
loop                : identifier-sequence /LEFT-FAT-ARROW /ITERATE termination-clause read-sequence* statement* /END
statement           : pointer-assignment | loop
read-sequence       : (tape-read | assignment)*
tape-read           : (INTEGER | IDENTIFIER) /RIGHT-SKINNY-ARROW IDENTIFIER
assignment          : IDENTIFIER /LEFT-FAT-ARROW (INTEGER | IDENTIFIER | case-select | evaluation)
evaluation          : /EVALUATE (INTEGER | IDENTIFIER) (operator | IDENTIFIER) (INTEGER | IDENTIFIER)
case-select         : /MATCH IDENTIFIER /IN hashmap default-clause?
hashmap             : /LEFT-BRACKET (hash-entry /COMMA?)* /RIGHT-BRACKET
hash-entry          : (INTEGER | STRING) /COLON hash-value
hash-value          : operator | OP? INTEGER
default-clause      : /OR hash-value
operator            : OP
identifier-sequence : IDENTIFIER+
termination-clause  : /UNTIL IDENTIFIER BOOLEAN-DYAD INTEGER
expression          : (expression | INTEGER | IDENTIFIER) operator (INTEGER | IDENTIFIER)

graphical-program   : /GRAPHICAL IDENTIFIER graphical-statement-sequence /END
graphical-statement-sequence : graphical-statement*
graphical-statement : graphical-loop | graphical-assignment | graph-call | IDENTIFIER
graphical-loop      : /FOR graphical-binding-set /COLON graphical-statement-sequence /END
graphical-binding-set : graphical-identifier-sequence /IN graphical-expression
graphical-expression : graphical-split | graphical-read | graphical-case-select | graphical-calculation | IDENTIFIER | graphical-number
graphical-number    : OP? INTEGER
graphical-split     : IDENTIFIER /BY delimiter
graphical-read      : /READ INTEGER /BY delimiter
graphical-assignment : IDENTIFIER /BOOLEAN-DYAD graphical-expression
graphical-case-select : /MATCH IDENTIFIER /IN hashmap default-clause?
graphical-identifier-sequence : (IDENTIFIER /COMMA?)+
graphical-calculation : graphical-expression operator graphical-expression
graph-call          : /GRAPH /DOT graphical-function-call (/DOT graphical-function-call)*
graphical-function-call : IDENTIFIER /OPEN-PAREN (graphical-expression /COMMA?)* /CLOSE-PAREN

countguesser-program   : /COUNTGUESSER IDENTIFIER read-block assume-block /END
read-block             : /FIND /COLON range-read /END
range-read             : /READ INTEGER /BY DELIMITER
assume-block           : /ASSUMING /COLON bool-exp* /END
bool-exp               : loop-expr | (arith-expr) comp (arith-expr) | bool-exp AND bool-exp
loop-expr              : (AND|OR|PADOR) binding /COLON bool-exp /END
arith-expr             : IDENTIFIER | INTEGER | (arith-expr OP arith-expr)
binding                : (IDENTIFIER /COMMA?)+
comp                   : BOOLEAN-DYAD | GEQ | LEFT-FAT-ARROW | NEQ
