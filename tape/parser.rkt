#lang brag
tape-program        : read statement*
read                : /READ INTEGER delimiter
delimiter           : DELIMITER
statement           : pointer-assignment | loop
pointer-assignment  : (INTEGER | IDENTIFIER) /LEFT-SKINNY-ARROW (INTEGER | IDENTIFIER)
loop                : identifier-sequence /LEFT-FAT-ARROW /ITERATE termination-clause tape-read statement /END
tape-read           : (INTEGER | IDENTIFIER) /RIGHT-SKINNY-ARROW IDENTIFIER
identifier-sequence : IDENTIFIER+
termination-clause  : /UNTIL IDENTIFIER BOOLEAN-DYAD INTEGER
