#lang brag
tape-program        : read statement*
read                : /READ INTEGER delimiter
delimiter           : DELIMITER
statement           : pointer-assignment | loop
pointer-assignment  : INTEGER /LEFT-SKINNY-ARROW INTEGER
loop                : identifier-sequence /LEFT-FAT-ARROW /ITERATE termination-clause statement+ /END
identifier          : IDENTIFIER
identifier-sequence : identifier+
termination-clause  : /UNTIL IDENTIFIER BOOLEAN-DYAD INTEGER
