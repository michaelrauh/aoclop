#lang brag
aoclop-program : /NEWLINE read scope-block /NEWLINE
read           : /READ INTEGER delimiter
scope-block    : /PIPE /DOWNSCOPE /PIPE op /PIPE /UPSCOPE
delimiter      : DELIMITER
op             : OP