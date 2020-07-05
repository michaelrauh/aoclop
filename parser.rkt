#lang brag
aoclop-program : /NEWLINE read scope-block /NEWLINE
read           : /READ INTEGER delimiter
scope-block    : /PIPE /DOWNSCOPE /PIPE all-ops /PIPE /UPSCOPE
delimiter      : DELIMITER
all-ops        : op*
op             : OP | OP /PIPE