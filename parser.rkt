#lang brag
aoclop-program : /NEWLINE read scope-block vecop /NEWLINE*
read           : /READ INTEGER delimiter
scope-block    : /PIPE /DOWNSCOPE /PIPE all-ops /PIPE /UPSCOPE
delimiter      : DELIMITER
all-ops        : (op | multop)*
op             : OP | OP /PIPE
multop         : MULTOP INTEGER /PIPE | MULTOP INTEGER
vecop          : /PIPE VECOP