#lang brag
tape-program        : read statement-sequence
statement-sequence  : statement*
read                : /READ INTEGER delimiter
delimiter           : DELIMITER
pointer-assignment  : (INTEGER | IDENTIFIER) /LEFT-SKINNY-ARROW (INTEGER | IDENTIFIER)
loop                : identifier-sequence /LEFT-FAT-ARROW /ITERATE termination-clause read-sequence statement /END
statement           : pointer-assignment | loop
read-sequence       : tape-read*
tape-read           : (INTEGER | IDENTIFIER) /RIGHT-SKINNY-ARROW IDENTIFIER
identifier-sequence : IDENTIFIER+
termination-clause  : /UNTIL IDENTIFIER BOOLEAN-DYAD INTEGER
