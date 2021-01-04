#lang brag
tape-program        : read statement-sequence
statement-sequence  : statement*
read                : /READ INTEGER delimiter
delimiter           : DELIMITER
pointer-assignment  : (INTEGER | IDENTIFIER) /LEFT-SKINNY-ARROW (INTEGER | IDENTIFIER)
loop                : identifier-sequence /LEFT-FAT-ARROW /ITERATE termination-clause read-sequence statement /END
statement           : pointer-assignment | loop
read-sequence       : (tape-read | assignment)*
tape-read           : (INTEGER | IDENTIFIER) /RIGHT-SKINNY-ARROW IDENTIFIER
assignment          : IDENTIFIER /LEFT-FAT-ARROW (INTEGER | IDENTIFIER | case-select | evaluation)
evaluation          : /EVALUATE (INTEGER | IDENTIFIER) (operator | IDENTIFIER) (INTEGER | IDENTIFIER)
case-select         : /MATCH IDENTIFIER /IN hashmap
hashmap             : /LEFT-BRACKET (INTEGER /COLON operator /COMMA?)* /RIGHT-BRACKET
operator            : OPERATOR
identifier-sequence : IDENTIFIER+
termination-clause  : /UNTIL IDENTIFIER BOOLEAN-DYAD INTEGER
