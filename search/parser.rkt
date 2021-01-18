#lang brag
search-program      : find-block? satisfying-block? return-block?
operator            : OPERATOR
find-block          : /FIND /COLON assignment-sequence /END
assignment-sequence : assignment*
assignment          : IDENTIFIER /IN range-expr
range-expr          : INTEGER /RIGHT-SKINNY-ARROW INTEGER
return-block        : /RETURN /COLON expression /END
expression          : (expression | INTEGER | IDENTIFIER) OPERATOR (INTEGER | IDENTIFIER)
satisfying-block    : /SATISFYING /COLON /FOREIGN function-call /IN IDENTIFIER /EQUALS INTEGER /END
function-call       : IDENTIFIER /OPEN-PAREN IDENTIFIER /COMMA IDENTIFIER /CLOSE-PAREN


